# 不靠谱颜论

颜林林的个人网站，记录技术探索、学术研究、生活感悟。

## 快速开始

### 开发模式

```bash
# 快速开发（推荐）
npm run dev

# 或完整开发模式
npm run serve
```

### 构建

```bash
# 快速构建（开发用）
npm run build:fast

# 完整构建（生产用）
npm run build
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

## 项目结构

```
├── content/          # 内容文件
├── layouts/          # 模板文件
├── static/           # 静态资源
├── src/scss/         # SCSS 源文件
├── config/           # Hugo 配置
├── docs/             # 文档
└── public/           # 构建输出（自动生成）
```

## 构建流程

### 完整构建流程 (`npm run build`)

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

### 字体文件管理

- FontAwesome 字体文件从 `node_modules/@fortawesome/fontawesome-free/webfonts/` 自动拷贝到 `static/webfonts/`
- 每次构建时自动更新，确保字体文件与依赖版本同步

详细说明请查看 [构建文档](docs/BUILD.md)。

## 许可证

MIT License
