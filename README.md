# 不靠谱颜论

颜林林的个人网站，记录技术探索、学术研究、生活感悟。

## 快速开始

### 开发

```bash
# 快速开发（推荐）
npm run dev

# 完整开发模式
npm run start
```

### 构建

```bash
# 生产构建
npm run build

# 快速构建（开发用）
npm run build:fast
```

### 内容检查

```bash
# 检查slug完整性和唯一性
npm run check:slugs
```

### 其他命令

```bash
# 查看所有命令
npm run help

# 清理构建目录
npm run clean
```

## 技术栈

- **静态站点生成器**: Hugo
- **样式**: Bootstrap 5 + SCSS + FontAwesome
- **构建工具**: npm scripts + Webpack + Sass

## 项目结构

```
├── content/          # 内容文件
├── layouts/          # 模板文件
├── static/           # 静态资源
├── src/              # 前端源码
├── scripts/          # 构建脚本
└── public/           # 构建输出
```

## 许可证

- **代码**: [MIT License](LICENSE)
- **内容**: [CC-BY-4.0](LICENSE-CC-BY-4.0)
