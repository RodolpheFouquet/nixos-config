{
  lib,
  config,
  pkgs,
  systemType ? null,
  ...
}:

lib.optionalAttrs (systemType == "nixos") {
  users.users.${config.var.username} = {
    isNormalUser = true;
    description = "${config.var.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "plugdev"
      "scanner"
      "lp"
      "kvm"
    ];
    shell = pkgs.fish;
  };

  environment.variables = {
    PATH = "$PATH:${config.var.userHome}/.local/bin";
  };

  programs.fish.enable = true;
  programs.dconf.enable = true;
}
