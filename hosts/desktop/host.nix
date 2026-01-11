{ inputs, ... }:

{
  # Desktop-specific host configuration
  networking.hostName = "vachicorne-desktop";

  # BTRFS autoscrub configuration
  # services.btrfs.autoScrub = {
  #   enable = true;
  #   fileSystems = [ "/" ];
  #   interval = "monthly";
  # };

  imports = [
    inputs.xremap-flake.nixosModules.default
  ];

  services.xremap = {
    enable = true;
    withWlroots = true;
    config = {
      keymap = [
        {
          name = "macOS Shortcuts";
          remap = {
            "Super-c" = "Ctrl-c";
            "Super-v" = "Ctrl-v";
            "Super-x" = "Ctrl-x";
            "Super-z" = "Ctrl-z";
            "Super-f" = "Ctrl-f";
            "Super-Shift-z" = "Ctrl-Shift-z";
            "Super-s" = "Ctrl-s";
            "Super-a" = "Ctrl-a";
            "Super-Left" = "Home";
            "Super-Right" = "End";
            "Alt-Left" = "Ctrl-Left";
            "Alt-Right" = "Ctrl-Right";
            "Super-Backspace" = "Ctrl-Backspace";
          };
        }
      ];
    };
  };
}
