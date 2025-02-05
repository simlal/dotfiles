{
  config,
  pkgs,
  ...
}: {
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
    # CLI tools
    atuin
    awscli2
    bat
    carapace
    starship
    xsel
    eza
    ripgrep
    fzf
    xkb-switch

    # fonts
    glibcLocales
    nerd-fonts.fira-code
    jetbrains-mono

    # libs
    man
    man-pages

    # docs
    pandoc
    texliveTeTeX

    # apps/gui/tui
    podman
    vscode
    zellij
    docker
    lazygit
    glow

    # cpp/rust toolchain
    gdb
    rustup
    gcc
    probe-rs

    ghostty

    # python config for global use
    (pkgs.python312.withPackages (python-pkgs: with python-pkgs; [ipykernel]))

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # zsh + ohmyzsh and plugins
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "nix-shell"
        "vi-mode"
      ];
    };
  };

  # ghostty
  # programs.ghostty = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     gtk4
  #     libadwaita
  #     pkg-config
  #   ];
  # };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      # Base nvim runtime deps
      gcc
      gnumake
      luajit

      # Language servers
      lua-language-server
      pyright
      nodePackages_latest.bash-language-server
      dockerfile-language-server-nodejs
      nixd
      nodePackages_latest.typescript-language-server
      marksman
      sqls
      clang-tools
      yaml-language-server
      cmake-language-server
      # omnisharp-roslyn
      # rust-analyzer

      # linters
      nodePackages_latest.eslint
      nodePackages.vscode-langservers-extracted

      # Formatters
      stylua
      ruff
      alejandra
      nodePackages_latest.prettier
      shfmt
      nodePackages_latest.sql-formatter
      yamlfmt
      # rustfmt

      # Extra tools / dependencies
      vimPlugins.markdown-preview-nvim
      nodejs_22
      yarn
      tslib
      mysql84
      postgresql
      luajitPackages.tiktoken_core
      platformio-core
      nodePackages_latest.katex
      # dotnet-sdk
      # rustc
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
    # ".config/wezterm/wezterm.lua".source = "${config.home.homeDirectory}/dotfiles/.config/wezterm/wezterm.lua";
    # ".config/ghostty".source = "${config.home.homeDirectory}/dotfiles/.config/ghostty";

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
