{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url =
      "github:nix-community/neovim-nightly-overlay";

    beaker-src = {
      url = "git+https://codeberg.org/gabrielf/beaker";
      flake = false;
    };

    omnisearch = {
      url = "git+https://codeberg.org/gabrielf/omnisearch";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, noctalia, ... } @ inputs:
  let
    system = "x86_64-linux";

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages.${system}.omnisearch =
      self.nixosConfigurations.xii.config.services.omnisearch.package;

    nixosConfigurations.xii = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs pkgs-unstable; };

      modules = [
        ./configuration.nix
        ./omnisearch.nix
        home-manager.nixosModules.home-manager

        {
          services.omnisearch = {
            enable = true;
            settings.server = {
              host = "127.0.0.1";
              port = 8087;
            };
          };

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
