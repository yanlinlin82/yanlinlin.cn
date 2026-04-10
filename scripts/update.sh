#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

QUIET_MODE=false
FORCE_MODE=false
HAS_WORK=false

usage() {
    echo "Usage: $0 [-q|--quiet] [-f|--force]"
    echo "  -q, --quiet    Suppress output when no update is needed"
    echo "  -f, --force    Run install and build even when code is up to date"
}

log() {
    if [ "$QUIET_MODE" = false ] || [ "$HAS_WORK" = true ]; then
        echo "$1"
    fi
}

fail() {
    echo "Error: $1" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || fail "Missing command: $1"
}

detect_build_script() {
    local scripts_json script_name

    scripts_json="$(npm run --json 2>/dev/null || true)"
    [ -n "$scripts_json" ] || fail "Failed to read scripts from package.json"

    has_script() {
        script_name="$1"
        printf '%s\n' "$scripts_json" | awk -v key="$script_name" '
            match($0, /^[[:space:]]*"([^"]+)"[[:space:]]*:/, m) {
                if (m[1] == key) {
                    found = 1;
                    exit 0;
                }
            }
            END { exit found ? 0 : 1 }
        '
    }

    if [ -n "${BUILD_SCRIPT:-}" ]; then
        if has_script "$BUILD_SCRIPT"; then
            echo "$BUILD_SCRIPT"
            return 0
        fi
        fail "Script not found in package.json: $BUILD_SCRIPT"
    fi

    if has_script "build:all"; then
        echo "build:all"
        return 0
    fi

    if has_script "build"; then
        echo "build"
        return 0
    fi

    fail "No build or build:all script found in package.json"
}

detect_output_dir() {
    echo "public"
}

ensure_clean_worktree() {
    if ! git diff --quiet --ignore-submodules -- || ! git diff --cached --quiet --ignore-submodules --; then
        fail "Working tree has uncommitted changes"
    fi

    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        fail "Working tree has untracked files"
    fi
}

worktree_is_clean() {
    if ! git diff --quiet --ignore-submodules -- || ! git diff --cached --quiet --ignore-submodules --; then
        return 1
    fi

    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        return 1
    fi

    return 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -q|--quiet)
            QUIET_MODE=true
            shift
            ;;
        -f|--force)
            FORCE_MODE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

cd "$PROJECT_ROOT"

require_command git
require_command npm

[ -d .git ] || fail "Current directory is not a Git repository: $PROJECT_ROOT"
[ -f package.json ] || fail "package.json not found: $PROJECT_ROOT/package.json"

CURRENT_BRANCH="$(git branch --show-current)"
[ -n "$CURRENT_BRANCH" ] || fail "Repository is not on a local branch"

UPSTREAM_REF="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
if [ -z "$UPSTREAM_REF" ]; then
    UPSTREAM_REF="origin/$CURRENT_BRANCH"
fi

REMOTE_NAME="${UPSTREAM_REF%%/*}"
REMOTE_BRANCH="${UPSTREAM_REF#*/}"

git fetch "$REMOTE_NAME" --prune >/dev/null 2>&1 || fail "Failed to fetch remote updates"
git rev-parse --verify "$UPSTREAM_REF" >/dev/null 2>&1 || fail "Upstream branch not found: $UPSTREAM_REF"

LOCAL_COMMIT="$(git rev-parse HEAD)"
REMOTE_COMMIT="$(git rev-parse "$UPSTREAM_REF")"
BUILD_OUTPUT_DIR_NAME="$(detect_output_dir)"
REMOTE_UPDATE_DETECTED=false
OUTPUT_MISSING=false

if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
    REMOTE_UPDATE_DETECTED=true
fi

if [ ! -d "$BUILD_OUTPUT_DIR_NAME" ]; then
    OUTPUT_MISSING=true
fi

if [ "$REMOTE_UPDATE_DETECTED" = false ] && [ "$FORCE_MODE" = false ] && [ "$OUTPUT_MISSING" = false ]; then
    if [ "$QUIET_MODE" = false ]; then
        echo "Code is already up to date"
        echo "Install and build steps were skipped"
    fi
    exit 0
fi

HAS_WORK=true

BUILD_SCRIPT_NAME="$(detect_build_script)" || fail "Failed to determine build script"
INSTALL_CMD="npm ci"
if [ ! -f package-lock.json ]; then
    INSTALL_CMD="npm install"
fi

log "Project root: $PROJECT_ROOT"
log "Current branch: $CURRENT_BRANCH"
log "Upstream branch: $UPSTREAM_REF"
log "Build script: npm run $BUILD_SCRIPT_NAME"
log "Build output directory: $BUILD_OUTPUT_DIR_NAME"

if [ "$FORCE_MODE" = true ]; then
    log "Force mode enabled; running install and build without pulling"
elif [ "$REMOTE_UPDATE_DETECTED" = true ]; then
    if worktree_is_clean; then
        log "Remote update detected; pulling latest changes"
        git pull --ff-only "$REMOTE_NAME" "$REMOTE_BRANCH" || fail "Failed to pull latest changes"
    elif [ "$OUTPUT_MISSING" = true ]; then
        log "Remote update detected, but working tree is dirty; skipping pull and rebuilding because output is missing"
    else
        ensure_clean_worktree
    fi
elif [ "$OUTPUT_MISSING" = true ]; then
    log "Code is up to date, but build output is missing; rebuilding without pulling"
else
    log "Code is up to date; running install and build"
fi

log "Installing dependencies with: $INSTALL_CMD"
$INSTALL_CMD || fail "Dependency installation failed"

log "Running build"
npm run "$BUILD_SCRIPT_NAME" || fail "Build failed"

[ -d "$BUILD_OUTPUT_DIR_NAME" ] || fail "Build completed but $BUILD_OUTPUT_DIR_NAME directory was not created"

log "Update completed successfully"
