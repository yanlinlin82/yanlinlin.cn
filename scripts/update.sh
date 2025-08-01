#!/bin/bash

# 设置错误时退出
set -e

# 获取脚本所在目录，并跳转到项目根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 跳转到项目根目录
cd "$PROJECT_ROOT"

# 解析命令行参数
QUIET_MODE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -q|--quiet)
            QUIET_MODE=true
            shift
            ;;
        *)
            echo "用法: $0 [-q|--quiet]"
            echo "  -q, --quiet    静默模式：无更新时不输出任何信息"
            exit 1
            ;;
    esac
done

# 静默模式下的日志函数
log() {
    if [ "$QUIET_MODE" = false ] || [ "$HAS_UPDATES" = true ]; then
        echo "$1"
    fi
}

# 保存当前分支名
CURRENT_BRANCH=$(git branch --show-current)

# 获取远程最新信息
git fetch origin > /dev/null 2>&1

# 检查是否有更新
LOCAL_COMMIT=$(git rev-parse HEAD)
REMOTE_COMMIT=$(git rev-parse origin/$CURRENT_BRANCH)

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    if [ "$QUIET_MODE" = false ]; then
        echo "✅ 代码已是最新版本，无需更新"
        echo "📦 跳过构建步骤"
    fi
    exit 0
else
    # 标记有更新，后续日志都会输出
    HAS_UPDATES=true
    
    log "🔄 开始检查代码更新..."
    log "📍 当前分支: $CURRENT_BRANCH"
    log "🔄 检测到代码更新，开始拉取最新代码..."
    
    # 拉取最新代码
    git pull origin $CURRENT_BRANCH
    
    log "📦 安装依赖..."
    npm install
    
    log "🏗️  开始构建..."
    rm -rf public
    npm run build
    
    log "✅ 更新完成！"
fi
