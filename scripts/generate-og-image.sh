#!/bin/bash

# Generate the Open Graph share image (static/images/og-image.jpg).
#
# Design: dark slate gradient background + site logo + site title/subtitle.
# Requires:
#   - ImageMagick 7 (magick)
#   - A CJK-capable font (Noto Sans CJK SC preferred; resolved via fontconfig,
#     overridable with the OG_FONT environment variable)
#
# Usage:
#   npm run generate:og-image
#   OG_FONT=/path/to/font.ttf npm run generate:og-image

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

OUTPUT="static/images/og-image.jpg"
LOGO="static/images/logo/geek-logo.svg"
TITLE="不靠谱颜论"
SUBTITLE="颜林林的个人主页"

require_command() {
    command -v "$1" >/dev/null 2>&1 || { echo "Error: Missing command: $1" >&2; exit 1; }
}

log() {
    echo "$1"
}

resolve_cjk_font() {
    local font
    if command -v fc-match >/dev/null 2>&1; then
        font="$(fc-match -f '%{file}' 'Noto Sans CJK SC' 2>/dev/null || true)"
        if [ -n "$font" ] && [ -f "$font" ]; then
            echo "$font"
            return
        fi
    fi
    for candidate in \
        /usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc \
        /usr/share/fonts/noto-cjk/NotoSansCJK-Regular.ttc \
        /usr/share/fonts/noto/NotoSansCJK-Regular.ttc; do
        if [ -f "$candidate" ]; then
            echo "$candidate"
            return
        fi
    done
    echo "Error: No CJK font found; install Noto Sans CJK SC or set OG_FONT" >&2
    exit 1
}

main() {
    cd "$PROJECT_ROOT"
    require_command magick

    local font="${OG_FONT:-$(resolve_cjk_font)}"

    log "Generating $OUTPUT"
    magick -size 1200x630 "gradient:#1e293b-#0f172a" \
        \( -background none "$LOGO" -resize 260x260 \) \
        -gravity west -geometry +140+0 -composite \
        -font "$font" \
        -pointsize 76 -fill "#f8fafc" -annotate +480+40 "$TITLE" \
        -pointsize 34 -fill "#94a3b8" -annotate +483+135 "$SUBTITLE" \
        "$OUTPUT"

    log "Done: $OUTPUT ($(magick identify -format '%wx%h' "$OUTPUT" 2>/dev/null || echo 'unknown size'))"
}

main "$@"
