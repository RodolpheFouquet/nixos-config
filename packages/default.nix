{pkgs, ...}:{
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
    fastfetch
    waybar
    gleam
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.fira-code
    nil
  ];

  
  fonts.fontconfig.enable = true;
}
