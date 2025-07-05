{ inputs, config, pkgs, ... }:

{
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    monitor = [
      "DP-6, 5120x1440@240,0x0,1"
    ];

    exec-once = [
      "waybar"
      "google-chrome-stable"
      "discord"
      "steam"
      "ghostty"
    ];

    input = {
      kb_layout = "us";
      kb_variant = "intl";
      follow_mouse = 1;
      touchpad = {
        natural_scroll = true;
      };
    };

    animations = {
      enabled = true;
      bezier = [
        "wind, -1.05, 0.9, 0.1, 1.05"
        "winIn, -1.1, 1.1, 0.1, 1.1"
        "winOut, -1.3, -0.3, 0, 1"
        "liner, 0, 1, 1, 1"
      ];
      animation = [
        "windows, 0, 6, wind, slide"
        "windowsIn, 0, 6, winIn, slide"
        "windowsOut, 0, 5, winOut, slide"
        "windowsMove, 0, 5, wind, slide"
        "border, 0, 1, liner"
        "fade, 0, 10, default"
        "workspaces, 0, 5, wind"
      ];
    };
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];
    bind =
      [
        "$mod, F, exec, google-chrome-stable"
        "$mod, Q, exec, ghostty"
        "$mod, R, exec, wofi --show drun"
        "$mod, V, togglefloating"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );

  };
  # Your home-manager configuration here
  home.packages = with pkgs; [
    vscode  # This will now be able to install unfree packages
    gh
    discord
    wezterm
    google-chrome
    git
    wget
    pavucontrol
    neovim
    wofi
    fzf
    ripgrep
    nodejs_24
    go
    ocaml
    ocamlPackages.findlib
    ocamlPackages.ocaml-lsp
    ocamlPackages.batteries
    opam
    killall
    ghostty
    gnumake
    gcc15
    font-awesome
    zig
    fastfetch
    waybar
  ];
}
