{
  inputs,
  config,
  pkgs,
  hostType ? "desktop",
  ...
}:

{
  imports = [
    inputs.nixvim.homeModules.nixvim

    ./packages/shared.nix
    ./niri
    ./neovim
    ./tmux
    ./noctalia
    ./hyprpaper
    ./git
    ./fastfetch

    ./foot
    ./mangowc
    # Import host-specific monitor configuration
    (./hosts + "/${hostType}/monitor.nix")
  ];

  programs.starship.enable = true;

  # Add ~/.local/bin to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Direnv integration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.whitelist = {
      prefix = [ "/home/vachicorne/Code" ];
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
      zoxide init fish | source
      bind \cf tms
      fastfetch
      set fish_greeting
    '';
  };
  # WinApps desktop integration
  xdg.desktopEntries.winapps = {
    name = "WinApps Manager";
    comment = "Manage Windows applications in Linux";
    exec = "winapps";
    icon = "application-x-ms-dos-executable";
    categories = [
      "System"
      "Utility"
    ];
    terminal = true;
  };

  programs.bash = {
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
