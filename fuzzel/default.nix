{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=14";
        icon-theme = "Papirus-Dark";
        terminal = "wezterm";
        width = 40;
        horizontal-pad = 40;
        vertical-pad = 20;
        inner-pad = 10;
        line-height = 30;
        lines = 10;
        tabs = 4;
        layer = "overlay";
        exit-on-keyboard-focus-loss = "yes";
      };

      colors = {
        background = "282828ff";
        text = "ebdbb2ff";
        match = "d79921ff";
        selection = "3c3836ff";
        selection-text = "fb4934ff";
        selection-match = "d79921ff";
        border = "d79921ff";
      };

      border = {
        width = 2;
        radius = 10;
      };
    };
  };
}
