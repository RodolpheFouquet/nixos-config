{
  config,
  pkgs,
  hostType ? "desktop",
  ...
}:
let
  commonPackages = with pkgs; [
    git
    gh
    wget
    discount
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
    golangci-lint
    delve
    impl
    killall
    gnumake
    clang-tools
    zig
    zls
    gopls
    nodePackages.typescript-language-server
    nodePackages.typescript
    elixir-ls
    gleam
    nixfmt-rfc-style
    nil
    gotools
    claude-code
    gemini-cli-bin
    antigravity
    opencode
    poppler-utils

    htop
    btop

    yazi
    fd
    eza
    zoxide
    ncdu

    nmap
    tcpdump

    pass
    gnupg

    jq
    yq
    tree
    unzip
    zip
    diff-so-fancy
    diffutils
    bc
    bacon

    yt-dlp
    ffmpeg
    fastfetch

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

  linuxPackages = with pkgs; [
    wkhtmltopdf
    firefox

    vscode
    discord
    ghostty
    google-chrome
    clang
    orca-slicer
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

    podman
    podman-compose
    freerdp

    btrfs-progs

    font-awesome
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.fira-code
    bibata-cursors

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
    adw-gtk3
    kdePackages.dolphin
    kdePackages.qt6ct
    kdePackages.qttools
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.spectacle
    kdePackages.kcalc
    kdePackages.kate
    kdePackages.konsole
    kdePackages.partitionmanager
    libsForQt5.qt5ct

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
    rofi
    feh
    betterlockscreen

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

  macPackages = with pkgs; [
    starship
    llvmPackages_19.clang
  ];
in
{
  home.packages = commonPackages ++ (if hostType == "mac-mini" then macPackages else linuxPackages);

  fonts.fontconfig.enable = true;
}
