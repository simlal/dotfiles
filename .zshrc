################ OH MY ZSH CONFIG ################
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
    nix-shell
    vi-mode
)
source $ZSH/oh-my-zsh.sh

################ User configuration ################
### GHOSTTY ###
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# GPG key for git and pinentry
export GPG_TTY=$(tty)

# Start new ssh agent if needed
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
    ssh-add $HOME/.ssh/id_25519 2>/dev/null
fi

# Aliases
# alias python="python3"
alias cat="bat"
# alias ipython="$HOME/.pyvenv/ipython-venv/bin/ipython3"
# alias icat="kitten icat"
alias dotfiles="cd $HOME/dotfiles"

# eza-aliases
alias ls='eza --color=always --group-directories-first --icons=always'
alias ll='eza -blT --header --icons=always --octal-permissions --group-directories-first --color=always --group'
alias l='eza -bl --header --git --color=always --group-directories-first --icons=always' 
alias la='eza -bla --header --git --color=always --group-directories-first --icons=always'

# git-aliases
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"

# nix home-manager shortcut
alias hms="home-manager switch"

# Wezterm cli from flatpak
alias wezterm="$(flatpak info --show-location org.wezfurlong.wezterm)/export/bin/org.wezfurlong.wezterm"
alias imgcat="wezterm imgcat"

# VERBOSE DEFAULT EDITOR
export EDITOR="nvim"

# Docker rootless daemon socket
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

######## PATH EXPORTS and bin ########
export PATH="/bin:$PATH"

# Language environment
export LANG=en_US.utf8
export LC_CTYPE=en_US.utf8
export LC_ALL=en_US.utf8

# local bin export to PATH
export PATH="$HOME/.local/bin:$PATH"

# Go-related path/bin
#export PATH="/usr/local/go/bin:$PATH"

# export GOPATH=$(go env GOPATH)
#export PATH="$(go env GOBIN):$PATH"

# MANPAGES
if [ -z "$MANPATH" ]; then
    export MANPATH=$(manpath)
fi

# Pico SDK path
PICO_SDK_PATH="$HOME/programming/pico-sdk/"
export PICO_SDK_PATH

######## terminal and shell tools  ########

export MANPAGER="sh -c 'col -bx | bat -l man -p'" # Use bat for manpage color
export MANROFFOPT="-c"

# starship prompt
eval "$(starship init zsh)"

# atuin search history
eval "$(atuin init zsh --disable-up-arrow)"

# carapace autocomplete
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# export ZELLIJ_AUTO_ATTACH=true

######### Nix-related ########
if [ -e /home/deck/.nix-profile/etc/profile.d/nix.sh ]; then . /home/deck/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
