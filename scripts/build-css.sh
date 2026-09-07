#!/bin/bash
# Build the main stylesheet by combining Bootstrap, Font Awesome,
# and the project's custom SCSS styles.
# Used by both the production build and the development server
# so that dev output matches the production output.
#
# Usage:
#   scripts/build-css.sh          # one-shot build (compressed)
#   scripts/build-css.sh --watch  # watch mode for development (expanded)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

# Make the local `sass` resolvable whether this script is invoked directly or
# via `npm`, so a missing global sass never kills the custom-SCSS compile.
export PATH="$PROJECT_ROOT/node_modules/.bin:$PATH"

# mktemp needs a writable dir. Some environments point TMPDIR at a read-only
# path (which makes mktemp fail, and the custom SCSS ends up empty and dropped
# from the combined output). Fall back to /tmp so that never happens silently.
if [ -z "${TMPDIR:-}" ] || [ ! -w "$TMPDIR" ]; then
    TMPDIR=/tmp
    export TMPDIR
fi

OUTPUT="static/assets/css/main.css"
CUSTOM_CSS="$(mktemp)"
trap 'rm -f "$CUSTOM_CSS"' EXIT

combine() {
    # Never overwrite a good main.css with a build whose custom SCSS failed to
    # compile -- that would silently drop every custom rule (e.g. the Chinese
    # paragraph first-line indent). Fail loudly instead.
    if [ ! -s "$CUSTOM_CSS" ]; then
        echo "WARN: custom SCSS output is empty; keeping previous $OUTPUT" >&2
        return 1
    fi
    mkdir -p "$(dirname "$OUTPUT")"
    {
        cat node_modules/bootstrap/dist/css/bootstrap.min.css
        cat node_modules/@fortawesome/fontawesome-free/css/fontawesome.min.css
        sed 's#\.\./webfonts#../fonts#g' node_modules/@fortawesome/fontawesome-free/css/solid.min.css
        sed 's#\.\./webfonts#../fonts#g' node_modules/@fortawesome/fontawesome-free/css/brands.min.css
        cat "$CUSTOM_CSS"
    } > "$OUTPUT"
}

build_once() {
    sass src/scss/main.scss "$CUSTOM_CSS" --style=compressed --no-source-map --no-charset
    combine
}

watch() {
    sass src/scss/main.scss "$CUSTOM_CSS" --style=expanded --no-source-map --no-charset --watch &
    local last_mtime=""
    while true; do
        local mtime
        mtime="$(stat -c %Y "$CUSTOM_CSS" 2>/dev/null || echo 0)"
        if [ -s "$CUSTOM_CSS" ] && [ "$mtime" != "$last_mtime" ]; then
            last_mtime="$mtime"
            combine || true
        fi
        sleep 1
    done
}

if [ "${1:-}" = "--watch" ]; then
    watch
else
    build_once
fi
