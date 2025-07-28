#!/bin/bash

# 配置同步脚本 - 确保 package.json 和 data/site.json 保持一致
set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 日志函数
log() {
    echo -e "${GREEN}[SYNC]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# 检查文件是否存在
check_files() {
    if [[ ! -f "package.json" ]]; then
        echo "错误: package.json 不存在"
        exit 1
    fi
    
    if [[ ! -f "assets/site.json" ]]; then
        echo "错误: assets/site.json 不存在"
        exit 1
    fi
}

# 从 package.json 读取基本信息
get_package_info() {
    local name=$(node -e "console.log(require('./package.json').name)")
    local description=$(node -e "console.log(require('./package.json').description)")
    local author=$(node -e "console.log(require('./package.json').author)")
    local version=$(node -e "console.log(require('./package.json').version)")
    local license=$(node -e "console.log(require('./package.json').license)")
    
    echo "name:$name"
    echo "description:$description"
    echo "author:$author"
    echo "version:$version"
    echo "license:$license"
}

# 同步配置
sync_config() {
    log "检查配置一致性..."
    
    # 读取 package.json 信息
    local package_info=$(get_package_info)
    local package_name=$(echo "$package_info" | grep "^name:" | cut -d: -f2)
    local package_desc=$(echo "$package_info" | grep "^description:" | cut -d: -f2)
    local package_author=$(echo "$package_info" | grep "^author:" | cut -d: -f2)
    
    # 读取 site.json 信息
    local site_name=$(node -e "console.log(require('./assets/site.json').name)")
    local site_desc=$(node -e "console.log(require('./assets/site.json').description)")
    local site_author=$(node -e "console.log(require('./assets/site.json').author)")
    
    # 比较关键字段
    if [[ "$package_name" != "$site_name" ]]; then
        warn "name 不一致: package.json=$package_name, site.json=$site_name"
    fi
    
    if [[ "$package_author" != "$site_author" ]]; then
        warn "author 不一致: package.json=$package_author, site.json=$site_author"
    fi
    
    log "配置检查完成"
}

# 主函数
main() {
    check_files
    sync_config
}

# 执行主函数
main "$@" 