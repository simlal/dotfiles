#!/bin/bash

check_requirements() {
  required_clis=("brew" "git" "rsync")
  for cli in "${required_clis[@]}"; do
    if ! command -v "$cli" &>/dev/null; then
      echo "Error: $cli is not installed. Please install it before running this script."
      exit 1
    fi
  done
}

# Clone dotfiles from repo
setup_dotfiles() {
  # CONFIG MAKE SURE
  XDG_CONFIG_DIR="$HOME/.config"
  mkdir -p "$XDG_CONFIG_DIR"

  # Sync dotfiles
  echo "Cloning dotfiles repository..."
  if git clone --separate-git-dir="$HOME"/.dotfiles https://github.com/anandpiyer/.dotfiles.git tmpdotfiles; then
    echo "Successfully cloned dotfiles repository"
    if rsync --recursive --verbose --exclude '.git' tmpdotfiles/ "$HOME"/; then
      echo "Successfully synced dotfiles"
      rm -rf tmpdotfiles
    else
      echo "Error: Failed to sync dotfiles"
      rm -rf tmpdotfiles
      return 1
    fi
  else
    echo "Error: Failed to clone dotfiles repository"
    return 1
  fi
}

# Installing dev packages and tooling with brew + setting up oh-my-zsh/plugins
setup_dev_env() {
  # NOTE: Update as needed (i.e. tmux, zsh may be missing from base OS)
  brew_packages=(
    "atuin"
    "awscli"
    "bat"
    "carapace"
    "eza"
    "fd"
    "fzf"
    "gemini-cli"
    "gcc"
    "gh"
    "go"
    "helm"
    "inxi"
    "kind"
    "kubernetes-cli"
    "lazydocker"
    "lazygit"
    "mkcert"
    "neovim"
    "pnpm"
    "ripgrep"
    "sesh"
    "uv"
    "viu"
    "yazi"
    "zoxide"
  )

  failed_packages=()
  for package in "${brew_packages[@]}"; do
    echo "Installing $package via brew..."
    if ! brew install "$package"; then
      echo "Warning: Failed to install $package"
      failed_packages+=("$package")
    fi
  done

  if [ ${#failed_packages[@]} -gt 0 ]; then
    echo "Failed to install the following packages: ${failed_packages[*]}"
  fi

  # Installing oh-my-zsh AND plugins (non-interactive)
  echo "Installing oh-my-zsh..."
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    if [ $? -eq 0 ]; then
      echo "Successfully installed oh-my-zsh"
    else
      echo "Error: Failed to install oh-my-zsh"
      return 1
    fi
  else
    echo "oh-my-zsh already installed, skipping..."
  fi

  # Install zsh plugins
  echo "Installing zsh plugins..."
  ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
    if git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"; then
      echo "Successfully installed zsh-autosuggestions"
    else
      echo "Error: Failed to install zsh-autosuggestions"
    fi
  else
    echo "zsh-autosuggestions already installed, skipping..."
  fi

  if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
    if git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"; then
      echo "Successfully installed zsh-syntax-highlighting"
    else
      echo "Error: Failed to install zsh-syntax-highlighting"
    fi
  else
    echo "zsh-syntax-highlighting already installed, skipping..."
  fi
}

# Main script execution
echo Setting up config files utilities for new machine...

check_requirements && setup_dotfiles && setup_dev_env

echo "Done setting up dev environment on $(cat /etc/os-release) :)"
