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

### 其他命令

```bash
# 查看所有可用命令
npm run help

# 清理构建目录
npm run clean
```

## 技术栈

- **静态站点生成器**: Hugo
- **样式**: Bootstrap 5 + 自定义 SCSS
- **构建工具**: npm scripts

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

## 构建模式

- **快速构建**: 禁用 RSS 和 sitemap，构建速度更快
- **完整构建**: 包含所有功能，适合生产环境

详细说明请查看 [构建文档](docs/BUILD.md)。

## 许可证

MIT License
