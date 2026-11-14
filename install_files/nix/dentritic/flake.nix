{
  description = "Sway and Noctalia on xii";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.follows = "neovim-nightly-overlay/flake-parts";
    import-tree.url = "github:vic/import-tree";
    zotero-nixpkgs.url = "github:NixOS/nixpkgs/131cf0f911b8fee10ae531f91e391db3e74672a6";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swaymonad = {
      url = "github:nicolasavru/swaymonad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    beaker-src = {
      url = "git+https://git.bwaaa.space/beaker";
      flake = false;
    };

    serein = {
      url = "github:ViceVerse-cz/Serein";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zapfast = {
      url = "github:crmne/zapfast";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    omnisearch = {
      url = "git+https://git.bwaaa.space/omnisearch";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
