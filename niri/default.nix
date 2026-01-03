{ ... }:
{
  # Niri is configured at system level via configuration.nix
  # This file provides niri config via XDG config files

  xdg.configFile."niri/config.kdl".text = ''
    hotkey-overlay {
      skip-at-startup
    }

    input {
        keyboard {
            xkb {
                layout "us"
                variant "alt-intl"
            }
        }
        
        mouse {
            accel-speed 0.0
            accel-profile "flat"
        }
    }

    output "HDMI-A-1" {
        mode "3840x2160@120"
        position x=0 y=0
    }

    layout {
        gaps 16
        center-focused-column "never"
        
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        
        default-column-width {
            proportion 0.5
        }
    }

    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "blueman-applet"
    spawn-at-startup "google-chrome-stable"
    spawn-at-startup "discord"
    spawn-sh-at-startup "env DISPLAY=:0 steam"
    spawn-at-startup "wezterm"
    spawn-at-startup "openrgb" "--mode" "static" "--color" "8000FF"


    binds {
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }

        Mod+Ctrl+H { move-column-left; }
        Mod+Ctrl+L { move-column-right; }
        Mod+Ctrl+J { move-window-down; }
        Mod+Ctrl+K { move-window-up; }

        Mod+Q { spawn "wezterm"; }
        Mod+F { spawn "google-chrome-stable"; }
        Mod+R { spawn "walker"; }
        Mod+E { spawn "thunar"; }

        Mod+C { close-window; }
        Mod+V { toggle-window-floating; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Shift+L { spawn "hyprlock"; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Plus { set-column-width "+10%"; }
        Mod+Equal { set-column-width "+10%"; }

        Mod+1 { focus-workspace "browser"; }
        Mod+2 { focus-workspace "chat"; }
        Mod+3 { focus-workspace "steam"; }
        Mod+4 { focus-workspace "games"; }
        Mod+5 { focus-workspace "diy"; }

        Mod+Shift+1 { move-column-to-workspace "browser"; }
        Mod+Shift+2 { move-column-to-workspace "chat"; }
        Mod+Shift+3 { move-column-to-workspace "steam"; }
        Mod+Shift+4 { move-column-to-workspace "games"; }
        Mod+Shift+5 { move-column-to-workspace "diy"; }

        // Workspace navigation
        Mod+Shift+Up { focus-workspace-up; }
        Mod+Shift+Down { focus-workspace-down; }
        
      //  Mod+Ctrl+Up { move-window-to-workspace-up; }
     //   Mod+Ctrl+Right { move-column-to-workspace-right; }
        
        // Column management  
        Mod+M { maximize-column; }
        Mod+Shift+Comma { consume-or-expel-window-left; }
        Mod+Shift+Period { consume-or-expel-window-right; }
        
        // Overview and focus switching
        Mod+Tab { switch-focus-between-floating-and-tiling; }
        Mod+Space { open-overview; }
        
        // Show important hotkeys
        Mod+Shift+Slash { show-hotkey-overlay; }

        Mod+P { spawn "sh" "-c" "mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"; }
        Mod+Shift+P { spawn "sh" "-c" "mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"; }

        Mod+Shift+N { quit; }
        Mod+W { toggle-column-tabbed-display; }
    }


    workspace "browser"
    workspace "chat"
    workspace "steam"
    workspace "games"
    workspace "diy"

    window-rule {
        geometry-corner-radius 12
    }

    // Window rules for workspace assignments
    window-rule {
        match app-id="google-chrome"
        open-on-workspace "browser"
    }

    window-rule {
        match app-id="org.wezfurlong.wezterm"
        open-on-workspace "browser"
    }

    window-rule {
        match app-id="discord"
        open-on-workspace "chat"
    }

    window-rule {
        match app-id="steam"
        open-on-workspace "steam"
    }

    window-rule {
      match app-id=r#"^(Minecraft.*|mincreaft)"#
      open-on-workspace "games"

    }

    window-rule {
        match app-id="bambu-studio"
        open-on-workspace "5"
    }

    // Floating window rules
    window-rule {
        match app-id="pavucontrol"
        default-column-width { proportion 0.3; }
    }

    window-rule {
        match app-id="blueman-manager"
        default-column-width { proportion 0.3; }
    }

    window-rule {
        match app-id="nm-connection-editor"
        default-column-width { proportion 0.3; }
    }

    window-rule {
        match app-id="thunar"
        default-column-width { proportion 0.4; }
        opacity 0.9
    }

    animations {
        slowdown 1.0
        
        window-open {
            duration-ms 150
            curve "ease-out-expo"
        }
        
        window-close {
            duration-ms 150
            curve "ease-out-expo"
        }
        
        horizontal-view-movement {
            duration-ms 250
            curve "ease-out-expo"
        }
        
        workspace-switch {
            duration-ms 250
            curve "ease-out-expo"
        }
    }

    environment {
        QT_QPA_PLATFORM "wayland"
        DISPLAY ":0"
        WAYLAND_DISPLAY "wayland-1"
        XDG_SESSION_TYPE "wayland"
        GDK_BACKEND "wayland,x11"
        CLUTTER_BACKEND "wayland"
        SDL_VIDEODRIVER "wayland"
        _JAVA_AWT_WM_NONREPARENTING "1"
    }
  '';
}
