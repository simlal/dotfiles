{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deck";
  home.homeDirectory = "/home/deck";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Allow unfree packages like vscode
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    atuin
    awscli2
    bat
    carapace
    glibcLocales
    fira-code-nerdfont
    podman
    starship
    vscode
    xsel
    zellij
    docker
    eza
    man
    man-pages
    vim 
    ripgrep
    fzf
    pandoc
    texliveTeTeX
    lazygit

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      # Runtime deps
      gcc
      gnumake
      luajit
      nodejs_22
      yarn
      tslib

      # Language servers
      lua-language-server
      pyright
      nodePackages_latest.bash-language-server
      dockerfile-language-server-nodejs
      nixd
      nodePackages_latest.typescript-language-server
      marksman

      # linters
      nodePackages_latest.eslint

      # Formatters
      stylua
      ruff
      nixpkgs-fmt
      nodePackages_latest.prettier
      shfmt

      # Extra tools
      vimPlugins.markdown-preview-nvim

    ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".bashrc".source = "${config.home.homeDirectory}/dotfiles/.bashrc";
    ".zshrc".source = "${config.home.homeDirectory}/dotfiles/.zshrc";
    ".vimrc".source = "${config.home.homeDirectory}/dotfiles/.vimrc";
    ".vim/colors".source = "${config.home.homeDirectory}/dotfiles/.vim/colors";

    ".config/starship.toml".source = "${config.home.homeDirectory}/dotfiles/.config/starship.toml";
    ".config/atuin/config.toml".source = "${config.home.homeDirectory}/dotfiles/.config/atuin/config.toml";
    ".config/zellij/config.kdl".source = "${config.home.homeDirectory}/dotfiles/.config/zellij/config.kdl";
    ".config/nvim".source = "${config.home.homeDirectory}/dotfiles/.config/nvim";

    # ".config/Code/User/keybindings.json".source = "${config.home.homeDirectory}/dotfiles/.config/Code/User/keybindings.json";
    # ".config/Code/User/settings.json".source = "${config.home.homeDirectory}/dotfiles/.config/Code/User/settings.json";

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
      # EDITOR = vim
  };

  # Oh my zsh TODO migration


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
