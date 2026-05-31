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

> 修改 `src/scss/_custom.scss` 后，需要重新构建才会生效，运行 `npm run build:fast` 即可。

### 内容管理

#### 新建书评文章

书评文章的 slug 格式为 `YYYYMMDD-书评-书名拼音`，例如 `260129-书评-架构整洁之道`。

文章使用封面图片，存放在 `static/uploads/YYYY/MMDD/book-cover.png`。

使用 ImageMagick 准备封面图片：

```bash
# 从下载目录复制并缩放封面图片到文章目录
magick ~/Downloads/xxx.jpg -resize 250x static/uploads/2026/0523/book-cover.png
```

参数说明：
- `~/Downloads/xxx.jpg` — 下载的原始封面图片路径
- `-resize 250x` — 缩放宽度为 250 像素，高度按比例自动调整
- `static/uploads/2026/0523/` — 目标目录，`2026` 为年份，`0523` 为月份日期

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

# 更新node依赖包
npx npm-check-updates -u
npm install
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
