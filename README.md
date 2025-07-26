# 不靠谱颜论（Linlin Yan's Personal Website）

**http://yanlinlin.cn/**

[![Hugo](https://img.shields.io/badge/Hugo-0.148.1+-blue.svg)](https://gohugo.io/)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3.7-purple.svg)](https://getbootstrap.com/)
[![License](https://img.shields.io/badge/License-CC--BY--4.0-green.svg)](https://creativecommons.org/licenses/by/4.0/)

---

I am a scientific researcher and software programmer. My major is bioinformatics. I received PhD from School of Life Sciences, Peking University. I have more than 20 years experience on programming. My current work is research and development on precision medicine, including data analysis of high-throughput technology, such as next-generation sequencing. I am also interested in genomics and other -omics.

本人是一名研究者兼程序员，在北大取得生信专业博士学位，拥有20多年编程经验。目前我的主要兴趣是各类高通量组学数据分析，并在精准医疗领域做相应的技术研发工作。本人平时酷爱编程，崇尚开源，且喜欢写作。搭建此个人网站，自娱自乐的同时，既为记录平时点滴心得，也用于收集整理自己的各类产出作品。

## 🚀 快速开始

### 环境要求

- **Node.js** 16+ 
- **Hugo** 0.148.1+
- **Git**

### 安装步骤

1. **克隆仓库**

   ```bash
   git clone https://github.com/yanlinlin82/yanlinlin.cn.git
   cd yanlinlin.cn
   ```

2. **安装前端依赖**

   ```bash
   npm install
   ```

3. **构建前端资源**

   ```bash
   npm run build
   ```

4. **启动开发服务器**

   ```bash
   hugo server --port 13131
   ```

   访问 http://localhost:13131 查看网站

## 🛠️ 开发指南

### 前端开发

本项目使用现代化的前端构建工具：

- **Bootstrap 5.3.7** - UI 框架
- **Sass** - CSS 预处理器  
- **原生 JavaScript** - 现代 ES6+ 语法
- **Webpack** - JavaScript 打包

#### 开发命令

```bash
# 构建所有资源
npm run build

# 分别构建
npm run build:css    # 构建 CSS
npm run build:js     # 构建 JavaScript

# 开发模式（监听文件变化）
npm run dev          # 监听所有文件
npm run dev:css      # 只监听 CSS
npm run dev:js       # 只监听 JavaScript
```

#### 项目结构

```
src/
├── scss/
│   ├── main.scss          # 主样式文件
│   └── _custom.scss       # 自定义样式
└── js/
    └── main.js            # 原生 JavaScript

static/
├── css/
│   └── main.css           # 构建后的 CSS
└── js/
    └── main.js            # 构建后的 JavaScript
```

### 内容管理

- **文章**：`content/posts/` 目录
- **页面**：`content/` 根目录
- **模板**：`layouts/` 目录
- **静态资源**：`static/` 目录

### 部署

1. **构建生产版本**

   ```bash
   npm run build
   hugo --minify
   ```

2. **部署到服务器**

   ```bash
   # 将 public/ 目录内容上传到服务器
   rsync -avz public/ user@server:/path/to/website/
   ```

## 📁 项目结构

```
yanlinlin.cn/
├── content/              # 网站内容
│   ├── posts/           # 博客文章
│   └── _index.md        # 首页内容
├── layouts/             # Hugo 模板
│   ├── _default/        # 默认模板
│   └── partials/        # 部分模板
├── src/                 # 前端源码
│   ├── scss/           # Sass 样式
│   └── js/             # JavaScript
├── static/              # 静态资源
├── hugo.yaml           # Hugo 配置
├── package.json        # npm 配置
└── webpack.config.js   # Webpack 配置
```

## 🎨 技术特点

- ✅ **现代化构建**：使用 Sass 和 Webpack
- ✅ **无 jQuery 依赖**：纯原生 JavaScript
- ✅ **内置搜索**：Fuse.js 客户端搜索
- ✅ **响应式设计**：Bootstrap 5 框架
- ✅ **SEO 友好**：Hugo 静态站点生成
- ✅ **快速加载**：压缩和优化的资源
- ✅ **易于维护**：模块化的代码结构

## 📞 联系方式

- **个人微信号**：yanlinlin82

  ![yanlinlin82](static/images/weixin_scancode.jpg)

- **个人公众号**：不靠谱颜论

  ![不靠谱颜论](static/images/bukaopuyanlun-qrcode.jpg)

## 📄 许可证

本项目遵循 [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/) 协议。

---

⭐ 如果这个项目对你有帮助，请给它一个星标！
