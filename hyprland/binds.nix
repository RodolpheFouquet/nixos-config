{...}:{
  wayland.windowManager.hyprland.settings = {
   bindel = [
    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
  ];
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];
  bind =
    [
      "$mod, F, exec, google-chrome-stable"
      "$mod, Q, exec, ghostty"
      "$mod, R, exec, wofi --show drun"
      "$mod, V, togglefloating"
      "$mod, C, killactive"
      "$mod, S, togglespecialworkspace, magic"
      "$mod SHIFT, S, movetoworkspace, special:magic"
      "$mod SHIFT, L, exec, hyprlock"
      "$mod, T, exec, pypr toggle term"
      "$mod, E, exec, pypr toggle files"
      "$mod, M, exec, pypr toggle music"
      "$mod SHIFT, T, exec, pypr toggle_special term"
      "$mod, Z, exec, pypr zoom"
      "$mod SHIFT, Z, exec, pypr zoom ++0.5"
      
      # Monitor resolution fix for KVM switching
      "$mod SHIFT, R, exec, /home/vachicorne/.config/nixos/scripts/monitor-hotplug.sh"
      
      # Screenshots
      ", Print, exec, mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
      "$mod, Print, exec, mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"
      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, J, movewindow, d"
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, L, movewindow, r"
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
}
