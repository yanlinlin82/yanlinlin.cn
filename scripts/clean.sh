#!/bin/bash

# 清理脚本
set -e

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 日志函数
log() {
    echo -e "${GREEN}[CLEAN]${NC} $1"
}

# 清理构建目录
clean() {
    log "🧹 清理构建目录"
    rm -rf public/
    log "清理完成"
}

# 执行清理
clean
