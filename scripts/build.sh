#!/bin/bash

# 构建脚本 - 统一处理不同的构建模式
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo -e "${GREEN}[BUILD]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# 构建前端资源
build_assets() {
    log "构建前端资源..."
    
    # 构建CSS
    log "构建CSS..."
    local css_output="static/assets/css/main.css"
    local custom_css

    mkdir -p static/assets/css
    custom_css=$(mktemp)
    trap 'rm -f "$custom_css"' RETURN

    sass src/scss/main.scss "$custom_css" --style=compressed --no-source-map --no-charset

    {
        cat node_modules/bootstrap/dist/css/bootstrap.min.css
        cat node_modules/@fortawesome/fontawesome-free/css/fontawesome.min.css
        sed 's#\.\./webfonts#../fonts#g' node_modules/@fortawesome/fontawesome-free/css/solid.min.css
        cat "$custom_css"
    } > "$css_output"
    
    # 构建JavaScript
    log "构建JavaScript..."
    webpack --mode=production
    
    # 拷贝字体文件
    log "拷贝字体文件..."
    mkdir -p static/assets/fonts && cp node_modules/@fortawesome/fontawesome-free/webfonts/*.woff2 static/assets/fonts/
    
    log "前端资源构建完成"
}

# 主构建函数
build() {
    local mode=${1:-full}

    case $mode in
        "fast")
            log "🚀 快速构建模式 - 禁用 RSS、sitemap 和搜索索引"
            build_assets
            hugo --config hugo.yaml,config/fast.yaml
            ;;
        "full")
            log "📦 完整构建模式 - 包含 RSS、sitemap 和搜索索引"
            build_assets
            hugo --config hugo.yaml
            ;;
        *)
            error "未知的构建模式: $mode (支持: fast, full)"
            ;;
    esac

    log "构建完成"
}

# 执行构建
build "$1"
