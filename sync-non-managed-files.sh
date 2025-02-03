#! /usr/bin/env bash

# Script to cp non home-manager managed files for before commit to git repo

function check_copy_OK() {
    if [ $? -ne 0 ]; then
        echo "Error copying files"
        exit 1
    fi
}

function create_dest_dir_if_not_exists() {
    if [ ! -d "$1" ]; then
        echo "Creating $1"
        mkdir -p "$1"
    fi
}

# Set the source and destination directories
DOTFILES_DIR="$HOME/dotfiles"

# Home-Manager home.nix
HOME_MANAGER_SOURCE_DIR="$HOME/.config/home-manager"
HOME_MANAGER_DEST_DIR="$DOTFILES_DIR/.config/home-manager"

create_dest_dir_if_not_exists "$HOME_MANAGER_DEST_DIR"

echo "Copying $HOME_MANAGER_SOURCE_DIR/home.nix -> $HOME_MANAGER_DEST_DIR/home.nix"
cp "$HOME_MANAGER_SOURCE_DIR/home.nix" "$HOME_MANAGER_DEST_DIR/home.nix"
check_copy_OK

# wezterm config bug with hms
WEZTERM_SOURCE_DIR="$HOME/.config/wezterm"
WEZTERM_DEST_DIR="$DOTFILES_DIR/.config/wezterm"

echo "Copying $WEZTERM_SOURCE_DIR/wezterm.lua -> $WEZTERM_DEST_DIR/wezterm.lua"
cp "$WEZTERM_SOURCE_DIR/wezterm.lua" "$HOME_MANAGER_DEST_DIR/wezterm.lua"
check_copy_OK

# VSCODE
VSCODE_SOURCE_DIR="$HOME/.config/Code/User"
VSCODE_SOURCE_RCFILES=("settings.json" "keybindings.json")

VSCODE_DEST_DIR="$DOTFILES_DIR/.config/Code/User"
create_dest_dir_if_not_exists "$VSCODE_DEST_DIR"

for file in "${VSCODE_SOURCE_RCFILES[@]}"; do
    if [ -f "$VSCODE_SOURCE_DIR/$file" ]; then
        echo "Copying $VSCODE_SOURCE_DIR/$file -> $VSCODE_DEST_DIR/$file"
        cp "$VSCODE_SOURCE_DIR/$file" "$VSCODE_DEST_DIR/$file"
    fi
done

check_copy_OK

echo "Done. Ready to commit and push to remote"
