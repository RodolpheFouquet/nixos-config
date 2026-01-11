{ ... }:
{
  # Niri is configured at system level via configuration.nix
  # This file provides niri config via XDG config files

  xdg.configFile."niri/config.kdl".text = ''
     hotkey-overlay {
       skip-at-startup
     }

     screenshot-path "~/Pictures/Screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png"

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

         border {
             off
         }

         focus-ring {
             active-gradient from="#7aa2f7" to="#bb9af7" angle=45;
             inactive-gradient  from="#24283b" to="#24283b";
         }

         default-column-width {
             proportion 0.5
         }
     }

     spawn-at-startup "xwayland-satellite"
     spawn-at-startup "noctalia-shell"

     spawn-at-startup "blueman-applet"
     spawn-at-startup "google-chrome-stable"
     spawn-at-startup "discord"
     spawn-sh-at-startup "env DISPLAY=:0 steam"
     spawn-at-startup "foot"
     spawn-at-startup "cider"
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

         Mod+Return { spawn "foot"; }
         Mod+G { spawn "google-chrome-stable"; }
         Mod+R { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
         Mod+E { spawn "dolphin"; }

         Mod+D { close-window; }
         Mod+W { toggle-window-floating; }
         Mod+Shift+F { fullscreen-window; }
         Mod+Shift+L { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }

         Mod+Minus { set-column-width "-10%"; }
         Mod+Plus { set-column-width "+10%"; }
         Mod+Equal { set-column-width "+10%"; }

         Mod+1 { focus-workspace "browser"; }
         Mod+2 { focus-workspace "chat"; }
         Mod+3 { focus-workspace "steam"; }
         Mod+4 { focus-workspace "games"; }
         Mod+5 { focus-workspace "diy"; }
         Mod+6 { focus-workspace "music"; }

         Mod+Shift+1 { move-column-to-workspace "browser"; }
         Mod+Shift+2 { move-column-to-workspace "chat"; }
         Mod+Shift+3 { move-column-to-workspace "steam"; }
         Mod+Shift+4 { move-column-to-workspace "games"; }
         Mod+Shift+5 { move-column-to-workspace "diy"; }
         Mod+Shift+6 { move-column-to-workspace "music"; }

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

         Mod+P { screenshot show-pointer=false; }
         Mod+Shift+P { screenshot-screen show-pointer=false; }

         Mod+Shift+N { quit; }
         Mod+T { toggle-column-tabbed-display; }
         
         XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+"; }
         XF86AudioLowerVolume { spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%-"; }
         XF86AudioMute { spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "toggle"; }
    }


     workspace "browser"
     workspace "chat"
     workspace "steam"
     workspace "games"
     workspace "diy"
     workspace "music"


     window-rule {
         clip-to-geometry true
         geometry-corner-radius 12
     }

     // Window rules for workspace assignments
     window-rule {
         match app-id="google-chrome"
         open-on-workspace "browser"
         default-column-width { proportion 0.5; }
     }

     window-rule {
         match app-id="foot"
         open-on-workspace "browser"
         default-column-width { proportion 0.33333; }
     }

    window-rule {
         match app-id="Antigravity"
         open-on-workspace "browser"
         default-column-width { proportion 0.33333; }
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
         match app-id="org.prismlauncher.PrismLauncher"
         open-on-workspace "steam"
         open-maximized false
         open-maximized-to-edges false
     }
     
     window-rule {
       match app-id=r#"^(Minecraft.*|mincreaft)$"#
       match app-id=r#"steam_app_.*"#
       match app-id=r#"^Project Zomboid$"#
       match app-id=r#"^gamescope$"#
       open-on-workspace "games"
       open-fullscreen true

       exclude title=""
     }
     
     window-rule {
         match app-id="bambu-studio"
         open-on-workspace "diy"
     }

     window-rule {
         match app-id="Cider"
         open-on-workspace "music"
     }

     // Floating window rules
     window-rule {
         match app-id="pavucontrol"
         open-floating true
         default-column-width { proportion 0.3; }
         default-window-height { proportion 0.3; }
         opacity 0.8
     }

     window-rule {
         match app-id="blueman-manager"
         open-floating true
         default-column-width { proportion 0.3; }
         default-window-height { proportion 0.3; }
         opacity 0.8
     }

     window-rule {
         match app-id="dolphin"
         default-column-width { proportion 0.4; }
         opacity 0.9
     }

     window-rule {
         match app-id="bambu-studio"
         open-on-workspace "diy"
     }

     window-rule {
         match app-id="Cider"
         open-on-workspace "music"
     }

     // Floating window rules
     window-rule {
         match app-id="pavucontrol"
         open-floating true
         default-column-width { proportion 0.3; }
         default-window-height { proportion 0.3; }
         opacity 0.8
     }

     window-rule {
         match app-id="blueman-manager"
         open-floating true
         default-column-width { proportion 0.3; }
         default-window-height { proportion 0.3; }
         opacity 0.8
     }

     window-rule {
         match app-id="dolphin"
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
