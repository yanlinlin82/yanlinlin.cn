#!/bin/bash

# Exit on error
set -e

# Get script directory and navigate to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Navigate to project root
cd "$PROJECT_ROOT"

# Parse command line arguments
QUIET_MODE=false
FORCE_MODE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -q|--quiet)
            QUIET_MODE=true
            shift
            ;;
        -f|--force)
            FORCE_MODE=true
            shift
            ;;
        *)
            echo "Usage: $0 [-q|--quiet] [-f|--force]"
            echo "  -q, --quiet    Quiet mode: no output when no updates"
            echo "  -f, --force    Force mode: build and deploy even without updates"
            exit 1
            ;;
    esac
done

# Log function for quiet mode
log() {
    if [ "$QUIET_MODE" = false ] || [ "$HAS_UPDATES" = true ]; then
        echo "$1"
    fi
}

# Save current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Fetch latest information from remote
git fetch origin > /dev/null 2>&1

# Check for updates
LOCAL_COMMIT=$(git rev-parse HEAD)
REMOTE_COMMIT=$(git rev-parse origin/$CURRENT_BRANCH)

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ] && [ "$FORCE_MODE" = false ]; then
    if [ "$QUIET_MODE" = false ]; then
        echo "✅ Code is up to date, no updates needed"
        if [ "$FORCE_MODE" = false ]; then
            echo "📦 Skipping build steps"
            echo "💡 Use -f or --force to build anyway"
        fi
    fi
    exit 0
else
    # Mark as having updates or force mode, subsequent logs will be output
    HAS_UPDATES=true
    
    log "🔄 Checking for code updates..."
    log "📍 Current branch: $CURRENT_BRANCH"
    
    if [ "$FORCE_MODE" = true ]; then
        log "🔨 Force mode: skipping code update check, building directly"
    else
        log "🔄 Code updates detected, pulling latest changes..."
        # Pull latest code
        git pull origin $CURRENT_BRANCH
    fi
    
    log "📦 Installing dependencies..."
    npm install
    
    log "🏗️  Starting build..."
    rm -rf public
    npm run build
    
    if [ "$FORCE_MODE" = true ]; then
        log "✅ Force build completed!"
    else
        log "✅ Update completed!"
    fi
fi
