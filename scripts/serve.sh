#!/bin/bash

# 开发服务器脚本
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# 日志函数
log() {
    echo -e "${GREEN}[SERVE]${NC} $1"
}

# 启动开发服务器
serve() {
    local mode=${1:-full}
    local port=${2:-1313}

    case $mode in
        "fast")
            log "🌐 启动开发服务器（快速模式）"
            # 启动资源监听
            "$SCRIPT_DIR/build-css.sh" --watch &
            webpack --mode=development --watch &
            hugo server --config hugo.yaml,config/fast.yaml --bind 0.0.0.0 --port $port
            ;;
        "full")
            log "🌐 启动开发服务器（完整模式）"
            # 启动资源监听
            "$SCRIPT_DIR/build-css.sh" --watch &
            webpack --mode=development --watch &
            hugo server --config hugo.yaml --bind 0.0.0.0 --port $port
            ;;
        *)
            log "未知的服务器模式: $mode (支持: fast, full)"
            exit 1
            ;;
    esac
}

# 执行服务器启动
serve "$1" "$2"
