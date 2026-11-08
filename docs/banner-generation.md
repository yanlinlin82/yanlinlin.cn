# 题图生成（脚本方式）

本文档记录“用文生图生成位图题图”的路径与用法，供后续尝试。目前站内题图默认仍以手写 SVG 为主。

两条路径：本地 Z-Image-Turbo（已完成部署与验证，见末节）与云端 API 脚本（尚未验证，见下文）。

## 文件

- `scripts/generate-banner.py`：调用腾讯云混元文生图 API 的薄封装（仅用 Python 标准库，无第三方依赖）。

## 前提

- 已开通对应的文生图 API，并有余量与计费准备（付费、限流）。
- 出网：能访问 API 主机（如 `hunyuan.tencentcloudapi.com`）。本仓库的执行环境默认禁网，需要放行。
- 凭证只从环境变量读取，**不要写进代码，也不要提交**：
  - `TENCENTCLOUD_SECRET_ID`
  - `TENCENTCLOUD_SECRET_KEY`
  - `TENCENTCLOUD_REGION`（可选，默认 `ap-guangzhou`）

## 用法

```bash
TENCENTCLOUD_SECRET_ID=... TENCENTCLOUD_SECRET_KEY=... \
  python3 scripts/generate-banner.py \
    --prompt "深色科技风横幅，抽象账本格线，一束光沿对角线逐格点亮，画面无任何文字" \
    --negative-prompt "文字, 水印, 字母, 数字" \
    --resolution 1024:1024 \
    --out static/uploads/2026/1007/article-banner-ai.png
```

## 注意

- **尚未验证**：脚本还没对着真实接口跑通。开头三处常量 `SERVICE` / `ACTION` / `VERSION` 需按当前文档核对；若走的是“智能创作 / aiart”那条产品线，改这三行即可，签名逻辑通用。
- **比例**：接口没有 1200×500，先生成再裁剪：

  ```bash
  magick IN.png -resize 1200x -gravity center -crop 1200x500+0+0 +repage OUT.png
  ```

- **文字**：短小的 ASCII 标签（如包名）可以交给模型直接画出，实测能拼写正确；中文与长句仍会乱码（实测见下文）。出图后仍须逐字目检拼写。
- **第三方服务**：提示词会发送给服务商；请自行评估数据流向。

## 本地生成（Z-Image-Turbo，已实测）

2026-11-09 在本机部署并跑通，中文提示词可直接使用。与 llama.cpp 无关：`llama-server` 只服务语言模型，图像模型走独立的 `sd-server`。

### 环境

- GPU：RTX 4060 Laptop，7800 MiB 显存；系统内存 61 GB 供 offload。
- 运行时：`leejet/stable-diffusion.cpp`（ggml + CUDA，无 Python 依赖）
  - 源码 `/work/Projects/Public/stable-diffusion.cpp`，子模块需 `ggml` 与 `thirdparty/cutlass`
  - 构建：`cmake -B build -DSD_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=89 -DCMAKE_BUILD_TYPE=Release`，产物 `build/bin/sd-cli`、`build/bin/sd-server`
- 权重放 `~/.models/z-image/`（经 `hf-mirror.com` 下载）：

| 文件 | 用途 | 大小 |
|---|---|---|
| `z_image_turbo-Q6_K.gguf` | 扩散模型（`--diffusion-model`） | 5.26 GB |
| `Qwen3-4B-Instruct-2507-Q4_K_M.gguf` | 文本编码器（`--llm`） | 2.50 GB |
| `ae.safetensors` | FLUX VAE（`--vae`） | 335 MB |

### 命令行

实测 1200×504、8 步，约 16 秒（同一机器上 SDXL 1216×640、30 步约 33 秒）。

```bash
sd-cli --diffusion-model ~/.models/z-image/z_image_turbo-Q6_K.gguf \
  --vae ~/.models/z-image/ae.safetensors \
  --llm ~/.models/z-image/Qwen3-4B-Instruct-2507-Q4_K_M.gguf \
  -p "深色科技风横幅：两个环形模块，左侧暗淡被锁住，右侧亮起青色光，深海军蓝渐变，细密网格，极简，无文字" \
  --cfg-scale 1.0 --steps 8 -W 1200 -H 500 --seed 42 \
  --offload-to-cpu -o out.png
```

### 常驻服务

OpenAI 兼容的 `POST /v1/images/generations`，监听 26420 可与 26418／26419 的 `llama-server` 并存（已实测返回 200 与 `b64_json`）：

```bash
nohup sd-server --diffusion-model ~/.models/z-image/z_image_turbo-Q6_K.gguf \
  --vae ~/.models/z-image/ae.safetensors \
  --llm ~/.models/z-image/Qwen3-4B-Instruct-2507-Q4_K_M.gguf \
  --offload-to-cpu --listen-port 26420 > ~/zimage-server.log 2>&1 &
```

服务无鉴权选项（没有 `--api-key`），务必只监听 `127.0.0.1`。

### 注意事项

- **整篇文章当提示词不可用**：把 4819 字正文直接作为提示词时，模型把正文当成“要渲染的内容”，产出满是乱码文字的幻灯片式卡片（实测四版皆如此）。Turbo 模式下 `--cfg-scale 1.0` 没有无条件分支，负向提示词完全不起作用（同一 seed 加不加 `-n` 像素一致），只有换 seed 才会变。题图这种“画面无文字”的需求，必须先把文章压缩成一句画面描述再生成。
- **短标签可行，长文本不行**：把 `conda` 与 `conda-libmamba-solver` 两个 ASCII 标签写进提示词后，Z-Image 两个 seed 均把拼写写得完全正确，可直接用于题图；而中文正文、多行命令仍会乱码。标签控制在两个以内，出图后逐字核对。
- **中文提示词**：Qwen3-4B 编码器直接识别中文。SDXL 的 CLIP 不识别中文，逐字退化成字节 token，实测用同一篇中文文章做提示词会产出完全无关的画面。
- **Turbo 参数**：8 步、`--cfg-scale 1.0`；步数拉高收益很小。
- **尺寸按 8 对齐**：请求 1200×500 实际产出 1200×504，裁剪用 `-crop 1200x500+0+0`。
- **下载**：`black-forest-labs/FLUX.1-schnell` 受访问限制（403），VAE 改从 `Comfy-Org/Z-Image-Turbo/split_files/vae/ae.safetensors` 取；不要对已存在的错误响应文件用 `curl -C -`，续传会拼出损坏文件（表现为 `unknown format`）。
- **显存**：8 GB 不够整模型常驻，`--offload-to-cpu` 把权重放内存、按块送显存。
- **不支持**：Kolors、HunyuanDiT／HunyuanImage（本版仅 `hunyuan_video`）。中文原生可选的还有 Qwen-Image（20B，较重）与 ERNIE-Image。

### 两段式：先把文章压成画面描述

把整篇正文直接交给图像模型会得到乱码文字（见下文“注意事项”），正确做法是两段，并且两段在不同的地方完成：

1. **阶段一在 Agent 环境里做**：读全文，压成一句画面描述（≤60 字）。推荐用 DeepSeek API 完成，因为它更能守住“有限篇幅内必须对应原文核心”这一约束；文章不便外传时，改用本机 llama-server 加载 Qwen3-4B-Instruct，或手写。
2. **阶段二只负责出图**：把这句话交给渲染脚本，脚本不调用任何语言模型，也不读文章。

```bash
# 阶段一：Agent 环境中调用 DeepSeek（key 只从环境变量读，勿写入文件）
# 阶段二：python3 <skill>/scripts/render-banner.py --prompt-file prompt.txt --crop 1200x500
```

完整流程封存在全局 skill `article-banner-image` 中。

实测得到的描述（seed 42，示例）：

> 深海军蓝渐变背景中，青色辉光穿透细密对称网格，如两股流动的光流彼此呼应，形成静谧而平衡的极简结构。

当前题图（2026-11-09）用的是 DeepSeek 概括后再写的一句：两枚青色辉光齿轮被细密网格对称锁扣却错位半格，一束极简光桥补上咬合。

模型选择很重要：`qwen2.5-coder-7b` 会把任务当成写代码（返回 React 组件、代码块或复述指令），四次尝试全部不可用；换成通用的 `Qwen3-4B-Instruct-2507`（与 Z-Image 的文本编码器同一份权重）后一次通过。若用脚本自动化，务必在渲染前校验模型输出（含代码标记、非中文或过长则丢弃重试）。

## 参考

- 题图在文章中的引用方式见项目 `AGENTS.md` 的“Banner images（题图）”。
