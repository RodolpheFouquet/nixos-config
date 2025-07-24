{
  description = "Vachicorne's NixOS configuration";

  inputs = {
    # NixOS official package repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Desktop configuration
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          ./hosts/desktop/hardware-configuration.nix
          ./hosts/desktop/host.nix

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

      # Laptop configuration  
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          ./hosts/laptop/hardware-configuration.nix
          ./hosts/laptop/host.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vachicorne = import ./home.nix;
            home-manager.extraSpecialArgs = { 
              inherit inputs; 
              hostType = "laptop";
            };
          }
        ];
      };
    };
  };
}
