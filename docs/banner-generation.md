# 题图生成（脚本方式）

本文档记录“用文生图 API 生成位图题图”的脚本与用法，供后续尝试。目前站内题图默认仍以手写 SVG 为主。

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

- **文字**：本站题图约定“不出现文字”，而文生图模型常生成乱码文字，需在提示词里显式排除，并在出图后人工目检。
- **第三方服务**：提示词会发送给服务商；请自行评估数据流向。

## 参考

- 题图在文章中的引用方式见项目 `AGENTS.md` 的“Banner images（题图）”。
