{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    # Pinned nixpkgs-unstable revision with a working Zotero 7 build
    nixpkgs-unstable.url = "github:nixos/nixpkgs/90e227a9c3798950bc44654cfca872bc55d09e86";
        
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url =
      "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, neovim-nightly-overlay, home-manager, noctalia, ... } @ inputs: 
  let
    system = "x86_64-linux";
    
    # Instantiate unstable package set with unfree enabled
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.xii = nixpkgs.lib.nixosSystem {
      inherit system;
      # Pass inputs and pkgs-unstable to NixOS modules
      specialArgs = { inherit inputs pkgs-unstable; }; 
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # Pass inputs and pkgs-unstable to Home Manager modules
            extraSpecialArgs = {
              inherit inputs pkgs-unstable;
            };
            users.greg = {
              imports = [
                ./home.nix
                noctalia.homeModules.default
              ];
            };
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
