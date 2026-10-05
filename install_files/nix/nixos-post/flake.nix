{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    # 1. Add unstable nixpkgs input
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        
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
    
    # 2. Instantiate unstable package set
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.xii = nixpkgs.lib.nixosSystem {
      inherit system;
      # 3. Pass pkgs-unstable to NixOS modules alongside inputs
      specialArgs = { inherit inputs pkgs-unstable; }; 
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # 4. Pass pkgs-unstable into Home Manager modules
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
