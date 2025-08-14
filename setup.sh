#!/bin/bash

# Dotfiles SETUP script
# Run this on your CURRENT system to copy configs to dotfiles repo

set -e

DOTFILES_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configs to manage
CONFIGS=("niri" "helix" "nvim" "fuzzel" "nushell" "ghostty")

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

main() {
    log_info "Setting up dotfiles from current system configs"
    
    # Create .config directory
    mkdir -p .config
    
    # Copy configs
    for config in "${CONFIGS[@]}"; do
        if [ -d "$CONFIG_DIR/$config" ]; then
            log_info "Copying $config to dotfiles"
            cp -r "$CONFIG_DIR/$config" .config/
        else
            log_warn "$config directory not found in ~/.config, skipping"
        fi
    done
    
    # Create .gitignore
    cat > .gitignore << 'EOF'
# Ignore history files
.config/nushell/history.sqlite3*
.config/nushell/history.txt

# Ignore cache and temporary files
.config/*/cache/
.config/*/tmp/
*/.DS_Store
EOF
    
    log_info "Dotfiles setup complete!"
    log_info "Now run: git add . && git commit -m 'Initial dotfiles'"
}

main