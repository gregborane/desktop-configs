{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    nixpkgs-unstable = {
      url = "git+https://github.com/nixos/nixpkgs?ref=nixos-unstable&rev=7000e30129a0075d5f2f5341f237bf3a5f25950e";
    };
        
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
