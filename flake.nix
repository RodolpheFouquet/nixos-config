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
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    # Doom Emacs (Unstraightened fork)
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
    in
    {
      nixosConfigurations = {
        # Desktop configuration
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; hostName = "vachicorne-desktop"; systemType = "nixos"; };

          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            # ./configuration.nix # Loaded by dendritic
            ./hosts/desktop/hardware-configuration.nix
            ./hosts/desktop/host.nix
            ({
              imports = [
                inputs.nix-flatpak.nixosModules.nix-flatpak
              ];
            })

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              # home-manager.users.vachicorne = import ./home.nix; # Loaded by dendritic
              home-manager.extraSpecialArgs = {
                inherit inputs;
                hostType = "desktop";
              };
            }
          ] ++ dendriticLoader;
        };

        laptopnul = nixpkgs.lib.nixosSystem {
                        specialArgs = { inherit inputs; hostName = "laptopnul"; systemType = "nixos"; };
          
                        modules = [
                          { nixpkgs.hostPlatform = "x86_64-linux"; }
                          # ./configuration.nix # Loaded by dendritic
                          ./hosts/laptop/hardware-configuration.nix
                          ./hosts/laptop/host.nix
                          ({
                            imports = [
                              inputs.nix-flatpak.nixosModules.nix-flatpak
                            ];
                          })
          
                          home-manager.nixosModules.home-manager
                          {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            # home-manager.users.vachicorne = import ./home.nix; # Loaded by dendritic
                            home-manager.extraSpecialArgs = {
                              inherit inputs;
                              hostType = "laptop";
                            };
                          }          ] ++ dendriticLoader;
        };

        t440p = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; hostName = "t440p"; systemType = "nixos"; };

          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            # ./configuration.nix # Loaded by dendritic
            ./hosts/t440p/hardware-configuration.nix
            ./hosts/t440p/host.nix
            ({
              imports = [
                inputs.nix-flatpak.nixosModules.nix-flatpak
              ];
            })

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # home-manager.users.vachicorne = import ./home.nix; # Loaded by dendritic
              home-manager.extraSpecialArgs = {
                inherit inputs;
                hostType = "laptop";
              };
            }
          ] ++ dendriticLoader;
        };
      };

      # Darwin configurations
      darwinConfigurations = {
        # Mac Mini configuration
        mac-mini = darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; hostName = "vachicorne-mac-mini"; systemType = "darwin"; };

          modules = [
            { nixpkgs.hostPlatform = "aarch64-darwin"; }
            ./hosts/mac-mini/host.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # home-manager.users.vachicorne = import ./home-darwin.nix; # Loaded by dendritic
              home-manager.extraSpecialArgs = {
                inherit inputs;
                hostType = "mac-mini";
              };
            }
          ] ++ dendriticLoader;
        };
      };
    };
}
