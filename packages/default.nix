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
    wofi
    fzf
    ripgrep
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
    ranger
    fd
    eza
    
    # Network tools
    nmap
    tcpdump
    wireshark
    
    # Security tools
    pass
    gnupg
    
    # Additional development tools
    jq
    yq
    tree
    unzip
    zip
    diff-so-fancy
    
    mangohud
    gamescope
  ];

  fonts.fontconfig.enable = true;
}
