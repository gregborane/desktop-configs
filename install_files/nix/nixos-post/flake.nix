{
  description = "Hyprland on Nixos";

  inputs = {
      nixpkgs.url = "nixpkgs/nixos-unstable";

      neovim-nightly-overlay.url =
        "github:nix-community/neovim-nightly-overlay";

      home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { self, nixpkgs, neovim-nightly-overlay, home-manager, ... } @ inputs: { # Capture inputs here
    nixosConfigurations.xii = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # Pass inputs to modules
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
                inherit inputs;
                };
            users.greg = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
