{ pkgs, ... }:
{
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/json_schema.json",
      "logo": {
        "source": "/home/vachicorne/.config/nixos/cow.txt"
      },
      "display": {
        "separator": " -> "
      },
      "modules": [
        "title",
        "separator",
        {
          "type": "os",
          "key": "OS",
          "format": "VachixOS"
        },
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "display",
        "de",
        "wm",
        "wmtheme",
        "theme",
        "icons",
        "font",
        "cursor",
        "terminal",
        "terminalfont",
        "cpu",
        "gpu",
        "memory",
        "swap",
        "disk",
        "localip",
        "battery",
        "poweradapter",
        "locale",
        "break",
        "colors"
      ]
    }
  '';
}