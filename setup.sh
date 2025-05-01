#!/bin/bash

echo Setting up config files and utilities for devcontainer...

# Symlink config and some share dirs
XDG_CONFIG_DIR="$HOME/.config"
mkdir -p "$XDG_CONFIG_DIR"

DOTFILES_DIR="$PWD/dotfiles" # Cloned dotfiles

ln -sf "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES_DIR/.config/atuin" "$HOME/.config/atuin"
ln -sf "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty"
ln -sf "$DOTFILES_DIR/.config/posting" "$HOME/.config/posting"
ln -sf "$DOTFILES_DIR/.config/lazygit" "$HOME/.config/lazygit"
ln -sf "$DOTFILES_DIR/.vim" "$HOME/.vim"
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

### Install utilities using brew ###
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
