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
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # This makes `inputs` available to your other .nix files
      specialArgs = { inherit inputs; };

      modules = [
        # Import your main system configuration
        ./configuration.nix

        # Import the Home Manager NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Define your user and point to their dedicated home.nix
          home-manager.users.vachicorne = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
