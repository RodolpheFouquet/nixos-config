{
  lib,
  config,
  pkgs,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      epson-escpr
      epson-escpr2
      canon-cups-ufr2
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
      postscript-lexmark
    ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      hplipWithPlugin
      sane-airscan
    ];
  };
}
