{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"
      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- Theme
      config.color_scheme = 'GruvboxDark'

      -- Font configuration
      config.font_size = 11.0

      -- Window configuration
      config.window_decorations = "NONE"
      config.window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
      }

      -- Cursor configuration
      config.default_cursor_style = 'SteadyBlock'

      -- Terminal behavior
      config.enable_tab_bar = false

      -- Keybindings
      config.keys = {
        -- Sessionizer binding (Ctrl+F)
        {
          key = 'f',
          mods = 'CTRL',
          action = wezterm.action.Multiple {
            wezterm.action.SendString '\x1b[24~f', -- Trigger fish sessionizer binding
          },
        },
      }

      return config
    '';
  };
}
