{
  description = "Vachicorne's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:aylur/ags";
    astal.url = "github:aylur/astal";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      ...
    }@inputs:
    let
      dendriticLoader = import ./lib/dendritic.nix { inherit (nixpkgs) lib; } ./.;

      commonDarwinModules = [
        ./hosts/mac-mini/host.nix
        ./hosts/mac-mini/monitor.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            hostType = "mac-mini";
          };
        }
      ];

      commonNixosModules = [
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        inputs.nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    in
    {
      nixosConfigurations =
        let
          makeNixosHost =
            name: hostFile: hostType: hardwareFile:
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs;
                hostName = name;
                systemType = "nixos";
              };

              modules =
                commonNixosModules
                ++ [
                  ./configuration.nix
                  hardwareFile
                  hostFile
                  {
                    home-manager.extraSpecialArgs = {
                      inherit inputs hostType;
                    };
                  }
                ]
                ++ dendriticLoader;
            };
        in
        {
          desktop =
            makeNixosHost "vachicorne-desktop" ./hosts/desktop/host.nix "desktop"
              ./hosts/desktop/hardware-configuration.nix;

          laptopnul =
            makeNixosHost "laptopnul" ./hosts/laptop/host.nix "laptop"
              ./hosts/laptop/hardware-configuration.nix;

          t440p =
            makeNixosHost "t440p" ./hosts/t440p/host.nix "t440p"
              ./hosts/t440p/hardware-configuration.nix;
        };

      darwinConfigurations = {
        mac-mini = darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            hostName = "vachicorne-mac-mini";
            systemType = "darwin";
          };

          modules = commonDarwinModules ++ dendriticLoader;
        };
      };
    };
}
