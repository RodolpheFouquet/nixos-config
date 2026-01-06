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
    fzf
    ripgrep
    direnv
    nodejs_24
    go
    killall
    gnumake
    gcc
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
    cmake
    ninja
    ccache
  ];

  # Linux-specific packages
  linuxPackages = with pkgs; [
    # GUI applications
    vscode
    discord
    wezterm
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
    ghostscript
    dnslookup

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
    parted
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
    thunar

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
