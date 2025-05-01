#!/bin/bash

echo Setting up config files and utilities for devcontainer...

# Symlink config and some share dirs
XDG_CONFIG_DIR="$HOME/.config"
mkdir -p "$XDG_CONFIG_DIR"

DOTFILES_DIR="$PWD" # Cloned dotfiles

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
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found, installing..."
  # Install build-essential for Homebrew
  sudo apt-get update && sudo apt-get install -y build-essential
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for the current session and permanently
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.bashrc"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.zshrc"
  echo "Homebrew installed! Proceeding to utilities"
else
  echo "Homebrew already installed, skipping install."
fi

# Installing dev packages and tooling
packages=(
  gcc
  atuin
  awscli
  bat
  carapace
  eza
  fd
  fzf
  lazygit
  mysql-client
  neovim
  node
  pnpm
  ripgrep
  starship
  zoxide
)

for package in "${packages[@]}"; do
  echo "Installing $package via brew..."
  brew install $package
done

echo "Done setting up devcontainer on $(cat /etc/os-release) container!"
