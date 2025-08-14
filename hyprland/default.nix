{
  ...
}:
{
  imports = [
    ./binds.nix
    ./rules.nix
    ./env.nix
    ./animations.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./pyprland.nix
  ];
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      # Monitor configuration is now handled by host-specific files
      # See hosts/{desktop,laptop}/monitor.nix

      misc = {
        layers_hog_keyboard_focus = true;
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = false;
        vfr = true; # Variable Frame Rate
        vrr = 2; # Variable Refresh Rate  Might need to set to 0 for NVIDIA/AQ_DRM_DEVICES
        # Screen flashing to black momentarily or going black when app is fullscreen
        # Try setting vrr to 0

        #  Application not responding (ANR) settings
        enable_anr_dialog = true;
        anr_missed_pings = 20;
      };

      workspace = [
        "1, name:work, persistent:true"
        "2, name:chat, persistent:true"
        "3, name:steam, persistent:true"
        "4, name:games, persistent:true"
        "5, name:DIY, persistent:true"
      ];

      ecosystem = {
        no_donation_nag = true;
        no_update_news = false;
      };

      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2; # change to 1 if want to disable
        enable_hyprcursor = true;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      render = {
        direct_scanout = 1;
      };

      decoration = {
        rounding = 10;
        
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(d79921ee) rgba(cc241dee) 45deg";
        "col.inactive_border" = "rgba(3c3836aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      master = {
        new_status = "master";
        new_on_top = 1;
        mfact = 0.5;
      };

      exec-once = [
        "waybar"
        "hyprpaper"
        "mako"
        "blueman-applet"
        "google-chrome-stable"
        "discord"
        "steam"
        "ghostty"
        "pypr"
        "hyprctl setcursor Bibata-Modern-Classic 24"
        "openrgb --mode static --color 8000FF"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };
    };
    
    extraConfig = ''
      # Resize submap
      submap = resize
      bind = , Right, resizeactive, 10 0
      bind = , Left, resizeactive, -10 0
      bind = , Up, resizeactive, 0 -10
      bind = , Down, resizeactive, 0 10
      bind = SHIFT, Right, resizeactive, 50 0
      bind = SHIFT, Left, resizeactive, -50 0
      bind = SHIFT, Up, resizeactive, 0 -50
      bind = SHIFT, Down, resizeactive, 0 50
      bind = , escape, submap, reset
      bind = , Return, submap, reset
      bind = SUPER, W, submap, reset
      submap = reset
    '';
  };
}
