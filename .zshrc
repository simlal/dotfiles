################ OH MY ZSH CONFIG ################

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
    vi-mode
)
source $ZSH/oh-my-zsh.sh

################ User configuration ################

# Ghostty shell integration for Bash. This should be at the top of your bashrc!
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# GPG key for git and pinentry
export GPG_TTY=$(tty)

# Start new ssh agent if needed
#if [ -z "$SSH_AUTH_SOCK" ]; then
#    eval "$(ssh-agent -s)"
#    ssh-add $HOME/.ssh/id_25519 2>/dev/null
#fi

######## Aliases ########
# alias python="python3"
alias cat="bat"

# dotfiles management
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# eza-aliases
alias ls='eza --color=always --group-directories-first --icons=always'
alias ll='eza -blT --header --icons=always --octal-permissions --group-directories-first --color=always --group --git-ignore'
alias l='eza -bl --header --git --color=always --group-directories-first --icons=always' 
alias la='eza -bla --header --git --color=always --group-directories-first --icons=always'

# git-aliases
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"

# Atuin scripts
alias asr="atuin scripts run"
alias asl="atuin scripts list"

# Wezterm cli from flatpak
#alias wezterm="$(flatpak info --show-location org.wezfurlong.wezterm)/export/bin/org.wezfurlong.wezterm"
#alias imgcat="wezterm imgcat"

# tmux session manager
# alias ssession=$(sesh l -t -T -d -H | walker -d -f -k -p "Sesh sessions"); sesh cn --switch $ssession
alias psesh='sesh connect "$(sesh list --icons | fzf-tmux -p 80%,70% \
  --no-sort --ansi --border-label " sesh " --prompt "⚡  " \
  --header "  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find" \
  --bind "tab:down,btab:up" \
  --bind "ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)" \
  --bind "ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)" \
  --bind "ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)" \
  --bind "ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)" \
  --bind "ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)" \
  --bind "ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)" \
  --preview-window "right:55%" \
  --preview "sesh preview {}")"'

# VERBOSE DEFAULT EDITOR
export EDITOR="nvim"

# Docker rootless daemon socket
#export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

######## PATH EXPORTS and bin ########
#
# Ensure $PATH and environment variables are set up
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Export linuxbrew path for zsh
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# Cargo/rust path/bin
. "$HOME/.cargo/env"

# Go-related path/bin
#export PATH="/usr/local/go/bin:$PATH"

# export GOPATH=$(go env GOPATH)
#export PATH="$(go env GOBIN):$PATH"

######## terminal and shell tools  ########

# batcat
export MANPAGER="sh -c 'col -bx | bat -l man -p'" # Use bat for manpage color
export MANROFFOPT="-c"

# FZF coloring
export FZF_DEFAULT_OPTS="--ansi $FZF_DEFAULT_OPTS"

# starship prompt
eval "$(starship init zsh)"

# atuin search history
eval "$(atuin init zsh --disable-up-arrow)"

# carapace autocomplete
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
# zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'

# zoxide smart cd
eval "$(zoxide init zsh)"

# export ZELLIJ_AUTO_ATTACH=true

