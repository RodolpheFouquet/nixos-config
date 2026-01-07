{
  description = "Vachicorne's NixOS configuration";

  inputs = {
    # NixOS official package repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin for macOS
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # You can add other flake inputs here, for example:
    ags.url = "github:aylur/ags";
    astal.url = "github:aylur/astal";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # Desktop configuration
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./configuration.nix
            ./hosts/desktop/hardware-configuration.nix
            ./hosts/desktop/host.nix
            inputs.nix-flatpak.nixosModules.nix-flatpak

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vachicorne = import ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                hostType = "desktop";
              };
            }
          ];
        };

      };

      # Darwin configurations
      darwinConfigurations = {
        # Mac Mini configuration
        mac-mini = darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };

          modules = [
            { nixpkgs.hostPlatform = "aarch64-darwin"; }
            ./hosts/mac-mini/host.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vachicorne = import ./home-darwin.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                hostType = "mac-mini";
              };
            }
          ];
        };
      };
    };
}
