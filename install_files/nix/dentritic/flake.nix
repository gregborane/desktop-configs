{
  description = "Sway + Noctalia desktop shell";

  inputs = {
    # Latest stable nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # Unstable nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake parts utils
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # noctalia shell v5
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # xmonad like tiling for sway 
    swaymonad = {
      url = "github:nicolasavru/swaymonad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # latest nvim version
    neovim-nightly-overlay.url =
      "github:nix-community/neovim-nightly-overlay";

    # search utility for web
    beaker-src = {
      url = "git+https://git.bwaaa.space/beaker";
      flake = false;
    };

    # search utility for web
    omnisearch = {
      url = "git+https://git.bwaaa.space/omnisearch";
      flake = false;
    };

    # discord in rust
    serein = {
            url = "github:ViceVerse-cz/Serein";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    # whatsapp in rust
    zapfast = {
            url = "github:crmne/zapfast";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Nix home manager module 
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Wrapper Modules
    wrappers.url = "github:nix-community/nix-wrapper-modules";
  };

  # Default import-tree output
  outputs = inputs:
  # Pass all inputs to outputs
    inputs.flake-parts.lib.mkFlake {
      # Call mkFlake from flake-parts module
      inherit inputs; # Inherit inputs (required to get correct arch for self')
    } (inputs.import-tree ./modules); # Pass in all modules using import-tree
}
