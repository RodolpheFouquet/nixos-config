{ ... }:
{

  wayland.windowManager.hyprland.settings = {
    windowrule = [
      # "suppressevent maximize, class:.*"
      # "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    ];

    windowrulev2 = [
      "workspace 1, class:^(google-chrome)$"
      "workspace 2 silent, class:^(discord)$"
      "workspace 3 silent, class:(steam)$"
      "workspace 3, class:^(org.prismlauncher.PrismLauncher)$"
      "workspace 4, class:^(steam_app_.*)$"
      "workspace 4, xwayland:1,class:^(gamescope)$"
      "workspace 4, class:^(Minecraft.*|minecraft)$"
      "workspace 4, class:^(Project Zomboid)$"
      "workspace 5, class:^(BambuStudio)$"
      "maximize, class:^(Minecraft.*|minecraft)$"
      "float, title:^(scratchpad-term)$"
      "workspace special silent, title:^(scratchpad-term)$"
      "float, title:^(scratchpad-files)$"
      "workspace special silent, title:^(scratchpad-files)$"
      "float, title:^(scratchpad-music)$"
      "workspace special silent, title:^(scratchpad-music)$"
      "workspace 1, class:^(org.wezfurlong.wezterm)$,title:^(?!scratchpad-).*$"
    ];

  };
}
