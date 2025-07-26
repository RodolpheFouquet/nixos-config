{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode
    gh
    discord
    wezterm
    google-chrome
    git
    wget
    pavucontrol
    fzf
    ripgrep
    grim
    slurp
    wl-clipboard

    # Clipboard manager
    cliphist

    # Screen recording
    obs-studio
    wf-recorder

    # PDF viewer with vim bindings
    zathura

    # Development tools
    direnv
    podman
    podman-compose

    # BTRFS tools
    btrfs-progs
    snapper
    nodejs_24
    go
    killall
    ghostty
    gnumake
    gcc15
    font-awesome
    zig
    zls
    gopls
    nodePackages.typescript-language-server
    nodePackages.typescript
    elixir-ls
    fastfetch
    gleam
    nixfmt-rfc-style
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.fira-code
    bibata-cursors
    claude-code

    # System monitoring and management
    htop
    btop
    iotop
    powertop

    # File management
    yazi
    xfce.thunar
    fd
    eza
    zoxide
    ncdu
    parted

    # Network tools
    nmap
    tcpdump
    wireshark

    # Security tools
    pass
    gnupg

    # Bluetooth utilities
    bluez
    bluez-tools
    blueman

    # Printing and scanning
    simple-scan
    system-config-printer

    # Additional development tools
    jq
    yq
    tree
    unzip
    zip
    diff-so-fancy

    mangohud
    gamescope

    bambu-studio
    orca-slicer

    prismlauncher

    # ZMK firmware build toolchain
    python3
    python3Packages.pip
    python3Packages.west
    cmake
    ninja
    ccache
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
  ];

  fonts.fontconfig.enable = true;
}
