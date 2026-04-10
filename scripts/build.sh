#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
    echo "Usage: $0 [fast|full]"
    echo "  fast    Build without RSS, sitemap, or search index"
    echo "  full    Build the complete site output"
}

log() {
    echo "$1"
}

fail() {
    echo "Error: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || fail "Missing command: $1"
}

cleanup() {
    if [ -n "${CUSTOM_CSS_FILE:-}" ] && [ -f "$CUSTOM_CSS_FILE" ]; then
        rm -f "$CUSTOM_CSS_FILE"
    fi
}

build_css() {
    local css_output="static/assets/css/main.css"

    log "Building CSS"
    mkdir -p static/assets/css
    CUSTOM_CSS_FILE="$(mktemp)"

    sass src/scss/main.scss "$CUSTOM_CSS_FILE" --style=compressed --no-source-map --no-charset

    {
        cat node_modules/bootstrap/dist/css/bootstrap.min.css
        cat node_modules/@fortawesome/fontawesome-free/css/fontawesome.min.css
        sed 's#\.\./webfonts#../fonts#g' node_modules/@fortawesome/fontawesome-free/css/solid.min.css
        cat "$CUSTOM_CSS_FILE"
    } > "$css_output"
}

build_js() {
    log "Building JavaScript"
    webpack --mode=production
}

copy_fonts() {
    log "Copying font assets"
    mkdir -p static/assets/fonts
    cp node_modules/@fortawesome/fontawesome-free/webfonts/*.woff2 static/assets/fonts/
}

build_assets() {
    log "Building frontend assets"
    build_css
    build_js
    copy_fonts
}

run_hugo() {
    local mode="$1"

    case "$mode" in
        fast)
            log "Running fast site build"
            hugo --config hugo.yaml,config/fast.yaml
            ;;
        full)
            log "Running full site build"
            hugo --config hugo.yaml
            ;;
        *)
            fail "Unsupported build mode: $mode"
            ;;
    esac
}

main() {
    local mode="${1:-full}"

    case "$mode" in
        -h|--help)
            usage
            exit 0
            ;;
    esac

    cd "$PROJECT_ROOT"
    trap cleanup EXIT

    require_command sass
    require_command webpack
    require_command hugo

    log "Project root: $PROJECT_ROOT"
    build_assets
    run_hugo "$mode"
    log "Build completed successfully"
}

main "$@"
