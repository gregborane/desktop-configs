{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/131cf0f911b8fee10ae531f91e391db3e74672a6";
        
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
    
    # Instantiate unstable package set with zotero overridden from stable nixpkgs
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.xii = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs pkgs-unstable; }; 
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
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
