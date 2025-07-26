# Hugo 构建配置说明

## 概述

本项目使用 Hugo 静态网站生成器，支持两种构建模式：

- **完整构建**：包含所有功能，包括 RSS 和 sitemap
- **快速构建**：禁用 RSS 和 sitemap，构建速度更快

## 配置文件结构

```
├── hugo.yaml          # 主配置文件（完整构建）
├── config/
│   └── fast.yaml      # 快速构建配置覆盖
├── package.json       # npm scripts 配置
├── Makefile           # 构建脚本（备用）
└── scripts/
    └── build.sh       # 备用构建脚本
```

## 使用方法

### 使用 npm scripts（推荐）

```bash
# 查看所有可用命令
npm run help

# 完整构建（默认）
npm run build
# 或
npm run build:full

# 快速构建
npm run build:fast

# 开发服务器
npm run serve          # 完整模式
npm run serve:fast     # 快速模式
npm run dev            # 快速模式（别名）

# 清理构建目录
npm run clean
```

### 使用 Makefile（备用）

```bash
# 查看所有可用命令
make help

# 完整构建（默认）
make build
# 或
make build-full

# 快速构建
make build-fast

# 开发服务器
make serve          # 完整模式
make serve-fast     # 快速模式

# 清理构建目录
make clean
```

### 使用脚本

```bash
# 完整构建
./scripts/build.sh full

# 快速构建
./scripts/build.sh fast
```

### 直接使用 Hugo 命令

```bash
# 完整构建
hugo --config hugo.yaml

# 快速构建
hugo --config hugo.yaml,config/fast.yaml
```

## 配置差异

### 完整构建 (hugo.yaml)
- 包含 RSS 订阅源
- 包含 sitemap.xml
- 构建时间较长

### 快速构建 (hugo.yaml + config/fast.yaml)
- 禁用 RSS 订阅源
- 禁用 sitemap.xml
- 构建时间较短
- 添加 `params.fastBuild: true` 标记

## 性能对比

| 模式 | 页面数量 | 构建时间 | 功能 |
|------|----------|----------|------|
| 完整构建 | ~1141 | ~19秒 | RSS + Sitemap |
| 快速构建 | ~773 | ~5秒 | 仅基础功能 |

## 使用场景

- **开发阶段**：使用快速构建模式，提高开发效率
- **生产部署**：使用完整构建模式，确保所有功能可用
- **CI/CD**：根据需求选择合适的构建模式

## 命令对比

| 功能 | npm scripts | Makefile | 直接命令 |
|------|-------------|----------|----------|
| 查看帮助 | `npm run help` | `make help` | - |
| 完整构建 | `npm run build` | `make build` | `hugo --config hugo.yaml` |
| 快速构建 | `npm run build:fast` | `make build-fast` | `hugo --config hugo.yaml,config/fast.yaml` |
| 开发服务器 | `npm run serve` | `make serve` | `hugo server --config hugo.yaml` |
| 快速开发 | `npm run dev` | `make serve-fast` | `hugo server --config hugo.yaml,config/fast.yaml` |
| 清理 | `npm run clean` | `make clean` | `rm -rf public/` |

## 注意事项

1. 快速构建模式会禁用 RSS 和 sitemap，适合开发测试
2. 生产环境建议使用完整构建模式
3. 两种模式生成的页面内容完全一致，只是功能完整性不同
4. npm scripts 是推荐的使用方式，提供了更好的跨平台兼容性 