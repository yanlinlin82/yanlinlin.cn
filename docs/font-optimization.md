# 字体加载优化策略

## 概述

本站采用**系统字体优先**策略：不加载任何 Web 字体，直接使用各操作系统自带的字体。零网络请求、零版权风险、无字体闪变（FOUT/FOIT），且各平台的中文渲染均为系统级最优。

## 字体查找逻辑（CSS font-family 工作原理）

- 浏览器对文本**逐字符**从左到右遍历 `font-family` 列表，选取第一个"已安装且含有该字符字形"的字体；
- 中英混排时，拉丁文字由列表前段的拉丁字体承担，中文字形自动落到后续包含 CJK 字形的字体；
- 字体名称须与系统已安装字体**精确匹配**（大小写不敏感），含空格的名字需要加引号；
- 列表耗尽仍无匹配时，回退到通用族（`sans-serif` / `serif` / `monospace`），由操作系统决定默认字体。

## 字体栈

字体变量定义在 `src/scss/_custom.scss` 的 `:root` 中，各处通过 `font-family: var(--font-sans)` 引用。

### 无衬线（正文与界面）

```
-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 'Noto Sans CJK SC', sans-serif
```

| 平台 | 拉丁文字 | 中文字形 |
|---|---|---|
| macOS / iOS | SF（-apple-system） | 苹方（PingFang SC） |
| Windows | Segoe UI | 微软雅黑（Microsoft YaHei） |
| Android | Roboto | Noto Sans CJK SC |
| Linux | Helvetica Neue / Arial | Noto Sans CJK SC（若已安装） |

### 等宽（代码块、日期等）

```
ui-monospace, 'SF Mono', 'Cascadia Code', 'JetBrains Mono', Consolas, Menlo, Monaco, 'DejaVu Sans Mono', monospace
```

### 衬线（中文衬线场景）

```
'Noto Serif SC', 'Songti SC', SimSun, STSong, serif
```

## 版权说明

- 栈中字体均为操作系统自带（Apple、微软、Google 随系统发行）或开源字体，CSS 仅引用名称、不携带字体文件，**不涉及版权分发问题**；
- 注意：不得将系统专有字体（苹方、微软雅黑、宋体、华文系列等）以 `@font-face` 方式自托管到服务器——那属于未授权的再分发。

## 性能收益

- 无字体文件下载：零带宽消耗；
- 无 FOUT（隐形文字闪烁）与 FOIT（布局抖动）；
- 无需任何字体检测或回退脚本，页面加载路径更短。

## 跨平台表现

- 各操作系统使用的字体形态略有差异，但均为各自平台渲染质量最高的中文字体，可读性与观感统一；
- 博客类内容站不追求跨设备像素级一致，该取舍是业界公认的主流做法（Bootstrap、Tailwind 等默认均为系统字体栈）。
