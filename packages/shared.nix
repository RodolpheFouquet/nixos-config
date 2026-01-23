{
  pkgs,
  hostType ? "desktop",
  ...
}:

let
  # Packages that work on both Linux and macOS
  commonPackages = with pkgs; [
    # Core development tools
    git
    gh
    wget
    discount # Markdown compiler
    html-tidy
    shellcheck
    ispell
    hunspell
    hunspellDicts.en_US
    fzf
    ripgrep
    direnv
    nodejs_24
    go
    gomodifytags
    gotests
    gore
    killall
    gnumake
    gcc
    clang-tools
    zig
    zls
    gopls
    nodePackages.typescript-language-server
    nodePackages.typescript
    elixir-ls
    gleam
    nixfmt-rfc-style
    claude-code
    gemini-cli-bin
    antigravity
    opencode
    wkhtmltopdf
    firefox
    poppler-utils

    # System monitoring (cross-platform)
    htop
    btop

    # File management
    yazi
    fd
    eza
    zoxide
    ncdu

    # Network tools
    nmap
    tcpdump

    # Security tools
    pass
    gnupg

    # Development utilities
    jq
    yq
    tree
    unzip
    zip
    diff-so-fancy
    bc
    bacon

    # Media tools
    yt-dlp
    ffmpeg
    fastfetch

    # Programming languages and tools
    python3
    python3Packages.pip
    python3Packages.isort
    python3Packages.pytest
    pipenv
    cmake
    ninja
    ccache
    tmux-sessionizer
    obsidian
  ];

  # Linux-specific packages
  linuxPackages = with pkgs; [
    # GUI applications
    vscode
    discord
    foot
    google-chrome
    pavucontrol
    grim
    slurp
    wl-clipboard
    cliphist
    obs-studio
    wf-recorder
    zathura
    dig
    busybox
    usbutils
    ghostscript
    dnslookup
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    cobang
    libreoffice-qt
    hunspell

    # Container tools
    podman
    podman-compose
    freerdp

    # BTRFS tools
    btrfs-progs

    # Fonts
    font-awesome
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.fira-code
    bibata-cursors

    # Additional system tools
    iotop
    powertop
    wireshark
    _1password-gui
    proton-pass
    bluez
    bluez-tools
    blueman
    libnotify
    simple-scan
    system-config-printer
    mangohud
    gamescope
    prismlauncher
    rpi-imager
    protonvpn-gui
    kdePackages.dolphin

    # ZMK firmware build toolchain (Linux-specific)
    python3Packages.west
    dtc
    gcc-arm-embedded
    gperf
    python3Packages.pyelftools
    python3Packages.pykwalify
    python3Packages.canopen
    python3Packages.packaging
    python3Packages.progress
    python3Packages.psutil
    python3Packages.pylink-square
    python3Packages.pyserial
    python3Packages.pyyaml
    python3Packages.zcbor
    noctalia-shell
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum

    # Doom Emacs dependencies
    rustc
    cargo
    rust-analyzer
    nodePackages.stylelint
    nodePackages.js-beautify
    glslang
    ocamlPackages.dune_3
    ocamlPackages.utop
    ocamlPackages.ocp-indent
    ocamlPackages.merlin
  ];

  # macOS-specific packages
  macPackages = with pkgs; [
    # macOS-compatible alternatives
    rectangle # Window management
    raycast # Spotlight alternative (if available in nixpkgs)

    # Development tools that work well on macOS
    # Most GUI apps on macOS should be installed via Homebrew casks
  ];

in
{
  home.packages = commonPackages ++ (if hostType == "mac-mini" then macPackages else linuxPackages);

  fonts.fontconfig.enable = true;
}
