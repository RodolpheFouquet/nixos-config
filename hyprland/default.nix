{
  inputs, config, pkgs, ...
}:{
  imports = [
    ./binds.nix
    ./rules.nix
    ./env.nix
    ./animations.nix
  ];
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      monitor = [
        "DP-6, 5120x1440@240,0x0,1"
      ];

      misc = {
        layers_hog_keyboard_focus = true;
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = false;
        vfr = true; # Variable Frame Rate
        vrr = 2; #Variable Refresh Rate  Might need to set to 0 for NVIDIA/AQ_DRM_DEVICES
        # Screen flashing to black momentarily or going black when app is fullscreen
        # Try setting vrr to 0

        #  Application not responding (ANR) settings
        enable_anr_dialog = true;
        anr_missed_pings = 20;
      };


      ecosystem = {
        no_donation_nag = true;
        no_update_news = false;
      };

      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2; # change to 1 if want to disable
        enable_hyprcursor = false;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      render = {
        direct_scanout = 1;
      };

      master = {
        new_status = "master";
        new_on_top = 1;
        mfact = 0.5;
      };


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
    };
  };
}
