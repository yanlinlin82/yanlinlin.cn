#!/bin/bash

# Hugo 构建脚本
# 支持完整构建和快速构建两种模式

set -e

# 默认构建模式
BUILD_MODE=${1:-full}

case $BUILD_MODE in
    "fast"|"quick")
        echo "🚀 快速构建模式 - 禁用 RSS 和 sitemap"
        export HUGO_FAST_BUILD=true
        hugo --config hugo.yaml
        ;;
    "full"|"complete")
        echo "📦 完整构建模式 - 包含 RSS 和 sitemap"
        unset HUGO_FAST_BUILD
        hugo --config hugo.yaml
        ;;
    *)
        echo "用法: $0 [fast|full]"
        echo "  fast  - 快速构建，禁用 RSS 和 sitemap"
        echo "  full  - 完整构建，包含所有功能"
        exit 1
        ;;
esac

echo "✅ 构建完成！"
