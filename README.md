# 不靠谱颜论

颜林林的个人网站，记录技术探索、学术研究、生活感悟。

## 快速开始

### 开发模式

```bash
# 快速开发（推荐）
npm run dev

# 完整开发模式
npm run start

# 快速服务器模式
npm run serve:fast

# 完整服务器模式
npm run serve:full
```

### 构建

```bash
# 完整构建（生产用，默认）
npm run build

# 快速构建（开发用，禁用 RSS、sitemap 和搜索索引）
npm run build:fast

# 完整构建（包含所有功能）
npm run build:full
```

### 前端资源构建

```bash
# 构建所有前端资源（CSS + JavaScript + 字体文件）
npm run build:assets

# 单独构建 CSS
npm run build:css

# 单独构建 JavaScript
npm run build:js

# 单独拷贝字体文件
npm run copy:fonts
```

### 开发监听

```bash
# 监听所有前端资源变化
npm run dev:assets

# 监听 CSS 文件变化
npm run dev:css

# 监听 JavaScript 文件变化
npm run dev:js
```

### 配置管理

```bash
# 检查配置一致性
npm run sync
```

### 其他命令

```bash
# 查看所有可用命令
npm run help

# 清理构建目录
npm run clean
```

## 技术栈

- **静态站点生成器**: Hugo
- **样式**: Bootstrap 5 + 自定义 SCSS + FontAwesome 图标
- **构建工具**: npm scripts + Webpack + Sass

## 命令总览

| 类别 | 命令 | 说明 |
|------|------|------|
| **开发** | `npm run dev` | 快速开发模式（推荐） |
| | `npm run start` | 完整开发模式 |
| | `npm run serve:fast` | 快速服务器模式 |
| | `npm run serve:full` | 完整服务器模式 |
| **构建** | `npm run build` | 完整构建（默认） |
| | `npm run build:fast` | 快速构建 |
| | `npm run build:full` | 完整构建 |
| **资源** | `npm run build:assets` | 构建所有前端资源 |
| | `npm run build:css` | 构建 CSS |
| | `npm run build:js` | 构建 JavaScript |
| | `npm run copy:fonts` | 拷贝字体文件 |
| **监听** | `npm run dev:assets` | 监听所有资源变化 |
| | `npm run dev:css` | 监听 CSS 变化 |
| | `npm run dev:js` | 监听 JS 变化 |
| **工具** | `npm run clean` | 清理构建目录 |
| | `npm run sync` | 检查配置一致性 |
| | `npm run help` | 查看所有命令 |

## 项目结构

```
├── content/          # 内容文件
├── layouts/          # 模板文件
│   └── partials/     # 可重用模板组件
├── assets/           # 资源文件（Hugo 处理）
│   ├── site.json     # 网站配置
│   └── project.json  # 项目配置
├── static/           # 静态资源
├── src/              # 前端源码
│   ├── scss/         # SCSS 源文件
│   └── js/           # JavaScript 源文件
├── scripts/          # 构建脚本
├── config/           # Hugo 配置
└── public/           # 构建输出（自动生成）
```

## 构建流程

### 完整构建流程 (`npm run build` / `npm run build:full`)

1. **前端资源构建** (`npm run build:assets`)
   - 构建 CSS 文件 (`npm run build:css`)
   - 构建 JavaScript 文件 (`npm run build:js`)
   - 拷贝字体文件 (`npm run copy:fonts`)
2. **Hugo 静态站点生成**
   - 生成 HTML 页面
   - 生成 RSS 订阅
   - 生成站点地图
   - 生成搜索索引

### 快速构建流程 (`npm run build:fast`)

1. **前端资源构建** (同上)
2. **Hugo 静态站点生成** (禁用 RSS、sitemap 和搜索索引)

### 开发服务器

- **快速模式** (`npm run serve:fast`): 禁用 RSS、sitemap 和搜索索引，启动速度更快
- **完整模式** (`npm run serve:full`): 包含所有功能，适合最终测试

### 字体文件管理

- FontAwesome 字体文件从 `node_modules/@fortawesome/fontawesome-free/webfonts/` 自动拷贝到 `static/webfonts/`
- 每次构建时自动更新，确保字体文件与依赖版本同步

### 配置管理

- **`package.json`**: 只包含必需字段（name, version）和构建相关配置
- **`assets/site.json`**: 管理网站配置（标题、描述、关键词、社交媒体等）
- **`assets/project.json`**: 管理项目信息（作者、版本、许可证、关键词等）
- 运行 `npm run sync` 检查配置一致性并显示项目信息

## 许可证

MIT License
