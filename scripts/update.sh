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
    node -e '
const pkg = require("./package.json");
const scripts = pkg.scripts || {};
if (process.env.BUILD_SCRIPT) {
  const name = process.env.BUILD_SCRIPT;
  if (!scripts[name]) {
    process.stderr.write(`Script not found in package.json: ${name}\n`);
    process.exit(1);
  }
  process.stdout.write(name);
  process.exit(0);
}
if (scripts["build:all"]) {
  process.stdout.write("build:all");
  process.exit(0);
}
if (scripts.build) {
  process.stdout.write("build");
  process.exit(0);
}
process.stderr.write("No build or build:all script found in package.json\n");
process.exit(1);
'
}

ensure_clean_worktree() {
    if ! git diff --quiet --ignore-submodules -- || ! git diff --cached --quiet --ignore-submodules --; then
        fail "Working tree has uncommitted changes"
    fi

    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        fail "Working tree has untracked files"
    fi
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
require_command node
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

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ] && [ "$FORCE_MODE" = false ]; then
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

ensure_clean_worktree

if [ "$FORCE_MODE" = true ]; then
    log "Force mode enabled; running install and build without pulling"
else
    log "Remote update detected; pulling latest changes"
    git pull --ff-only "$REMOTE_NAME" "$REMOTE_BRANCH" || fail "Failed to pull latest changes"
fi

log "Installing dependencies with: $INSTALL_CMD"
$INSTALL_CMD || fail "Dependency installation failed"

log "Running build"
npm run "$BUILD_SCRIPT_NAME" || fail "Build failed"

[ -d public ] || fail "Build completed but public directory was not created"

log "Update completed successfully"
