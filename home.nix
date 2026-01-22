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
    ./emacs
    ./niri
    ./neovim
    ./tmux
    ./noctalia
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

  # Configure NPM to use ~/.local as prefix (binaries go to ~/.local/bin)
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.local";
  };

  # Ensure ~/.local/bin exists
  systemd.user.tmpfiles.rules = [
    "d %h/.local/bin 0755 - - -"
    "d %h/.local/share/nix-doom/straight/build-30.2 0755 - - -"
  ];

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

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum/TokyoNight".source = "${
    pkgs.fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Tokyo-Night-GTK-Theme";
      rev = "master";
      sha256 = "sha256-7H2n9wTaW8Db1RejWK071ITV1j5KIuzfql0Tx9WT6zM=";
    }
  }/themes/Tokyo-Night/kvantum";

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Kvantum-Tokyo-Night
  '';

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
