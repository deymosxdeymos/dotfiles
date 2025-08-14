#!/bin/bash

# Dotfiles INSTALL script
# Run this on a NEW system after cloning the dotfiles repo

set -e

DOTFILES_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

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

create_backup() {
    log_info "Creating backup at $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    for config in "${CONFIGS[@]}"; do
        if [ -e "$CONFIG_DIR/$config" ] && [ ! -L "$CONFIG_DIR/$config" ]; then
            log_info "Backing up existing $config"
            cp -r "$CONFIG_DIR/$config" "$BACKUP_DIR/"
        fi
    done
}

install_configs() {
    mkdir -p "$CONFIG_DIR"
    
    for config in "${CONFIGS[@]}"; do
        if [ -d "$DOTFILES_DIR/.config/$config" ]; then
            # Remove existing config if it exists
            if [ -e "$CONFIG_DIR/$config" ]; then
                if [ -L "$CONFIG_DIR/$config" ]; then
                    log_info "Removing existing symlink for $config"
                    rm "$CONFIG_DIR/$config"
                else
                    log_info "Removing existing $config directory"
                    rm -rf "$CONFIG_DIR/$config"
                fi
            fi
            
            log_info "Creating symlink for $config"
            ln -s "$DOTFILES_DIR/.config/$config" "$CONFIG_DIR/$config"
        else
            log_warn "$config not found in dotfiles, skipping"
        fi
    done
}

main() {
    log_info "Installing dotfiles on new system"
    
    # Check if we're in a dotfiles directory
    if [ ! -d ".config" ]; then
        log_error "No .config directory found. Are you in the dotfiles directory?"
        exit 1
    fi
    
    # Create backup of existing configs
    create_backup
    
    # Install configs
    install_configs
    
    log_info "Dotfiles installation complete!"
    log_info "Backup created at: $BACKUP_DIR"
}

main