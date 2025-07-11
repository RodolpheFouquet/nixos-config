{ ... }:
{

  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "suppressevent maximize, class:.*"
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    ];

    windowrulev2 = [
      "workspace 1, class:^(google-chrome)$"
      "workspace 1, class:^(com.mitchellh.ghostty)$"
      "workspace 2 silent, class:^(discord)$"
      "workspace 3 silent, class:(steam)$"
      "workspace 4, class:^(steam_app_.*)$"
      "workspace 4, xwayland:1,class:^(gamescope)$"
    ];

  };
}
