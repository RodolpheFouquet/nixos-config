{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./constants.nix
  ];

  config = lib.optionalAttrs (systemType == "nixos") {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    nixpkgs.config.allowUnfree = true;

    nixpkgs.overlays = [
      (final: prev: {
        cider = prev.callPackage (
          {
            lib,
            appimageTools,
            requireFile,
          }:

          appimageTools.wrapType2 rec {
            pname = "cider";
            version = "3.1.8";

            src = requireFile {
              name = "cider-v${version}-linux-x64.AppImage";
              url = "https://taproom.ciderapp.sh/";
              sha256 = "1b5qllzk1r7jpxw19a90p87kpc6rh05nc8zdr22bcl630xh8ql5k";
            };

            extraInstallCommands =
              let
                contents = appimageTools.extract { inherit pname version src; };
              in
              ''
                if [ -f $out/bin/${pname}-${version} ]; then
                  mv $out/bin/${pname}-${version} $out/bin/${pname}
                elif [ -f $out/bin/AppRun ]; then
                  mv $out/bin/AppRun $out/bin/${pname}
                fi

                if [ -f ${contents}/${pname}.desktop ]; then
                  install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
                  substituteInPlace $out/share/applications/${pname}.desktop \
                    --replace 'Exec=AppRun' 'Exec=${pname}'
                  sed -i 's/^Icon=.*/Icon=${pname}/' $out/share/applications/${pname}.desktop
                fi

                if [ -d ${contents}/usr/share/icons ]; then
                  cp -r ${contents}/usr/share/icons $out/share
                  chmod -R u+w $out/share
                fi

                if [ -f ${contents}/.DirIcon ]; then
                  install -m 444 -D ${contents}/.DirIcon $out/share/icons/hicolor/512x512/apps/${pname}.png
                elif [ -f ${contents}/${pname}.png ]; then
                   install -m 444 -D ${contents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
                fi
              '';

            meta = with lib; {
              description = "A new look into listening and enjoying Apple Music in style and performance.";
              homepage = "https://cider.sh/";
              maintainers = [ maintainers.nicolaivds ];
              platforms = [ "x86_64-linux" ];
            };
          }
        ) { };
      })
    ];

    system.autoUpgrade = {
      enable = true;
      dates = "04:00";
      randomizedDelaySec = "45min";
      persistent = true;
      flake = "${config.var.nixConfigPath}";
      flags = [
        "--update-input"
        "nixpkgs"
        "--no-write-lock-file"
        "-L"
      ];
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };
    };

    nix.settings.auto-optimise-store = true;
  };
}
