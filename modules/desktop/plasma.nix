{
  lib,
  config,
  pkgs,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    raopOpenFirewall = true;
    extraConfig.pipewire = {
      "10-airplay" = {
        "context.modules" = [
          { name = "libpipewire-module-raop-discover"; }
        ];
      };
    };
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = "org.kde.dolphin.desktop";
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };
}
