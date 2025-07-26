# 前端构建系统

本项目使用简化的现代化前端构建工具，在保持最佳实践的同时尽量减少依赖。

## 设计理念

- **简单优先**：只使用必要的工具
- **现代标准**：使用 SCSS 和原生 JavaScript
- **最小依赖**：避免不必要的转译和复杂配置
- **无 jQuery**：使用现代原生 JavaScript API

## 安装依赖

```bash
npm install
```

## 构建命令

### 构建所有资源
```bash
npm run build
```

### 分别构建
```bash
# 构建 CSS
npm run build:css

# 构建 JavaScript
npm run build:js
```

### 开发模式（监听文件变化）
```bash
# 监听所有文件变化
npm run dev

# 只监听 CSS 变化
npm run dev:css

# 只监听 JavaScript 变化
npm run dev:js
```

## 项目结构

```
src/
├── scss/
│   ├── main.scss          # 主样式文件（导入 Bootstrap + 自定义样式）
│   └── _custom.scss       # 自定义样式
└── js/
    └── main.js            # 原生 JavaScript（无 jQuery）

static/
├── css/
│   └── main.css           # 构建后的 CSS 文件
└── js/
    └── main.js            # 构建后的 JavaScript 文件
```

## 技术栈

- **Bootstrap 5.3.7**: UI 框架（CSS 本地构建，JS 使用 CDN）
- **Sass**: CSS 预处理器
- **原生 JavaScript**: 现代 ES6+ 语法，无 jQuery 依赖
- **Webpack**: JavaScript 打包工具（简化配置）

## 依赖说明

### 为什么选择这种方案？

1. **Bootstrap CSS 本地构建**：
   - 可以自定义 Bootstrap 变量
   - 只包含需要的组件
   - 更好的缓存控制

2. **Bootstrap JS 使用 CDN**：
   - 减少构建复杂度
   - 利用 CDN 缓存
   - 自动获取安全更新

3. **原生 JavaScript**：
   - 无 jQuery 依赖，更轻量
   - 使用现代浏览器 API
   - 更好的性能和可维护性

4. **简化构建流程**：
   - 不使用 Babel 转译
   - 直接使用现代浏览器支持的语法
   - 更快的构建速度

## 现代 JavaScript 特性

项目使用以下现代 JavaScript 特性：

- **ES6 模块**：`import/export`
- **箭头函数**：`() => {}`
- **模板字符串**：`` `Hello ${name}` ``
- **解构赋值**：`const { a, b } = obj`
- **现代 DOM API**：`querySelector`, `addEventListener`
- **类语法**：`class MyClass`

## 开发流程

1. 修改 `src/scss/` 中的样式文件
2. 修改 `src/js/` 中的 JavaScript 文件
3. 运行 `npm run build` 构建资源
4. 启动 Hugo 服务器查看效果

## 优势

- **构建速度快**：简化的工具链
- **维护简单**：最少的依赖和配置
- **现代标准**：使用 SCSS 和原生 JavaScript
- **无 jQuery 依赖**：更轻量，更现代
- **灵活性强**：可以轻松自定义 Bootstrap
- **生产就绪**：压缩和优化后的文件
