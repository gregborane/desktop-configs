{ pkgs }:

let
  # nixpkgs commit that contains Zotero 10.0.2
  zoteroNixpkgs = builtins.getFlake
    "github:NixOS/nixpkgs/131cf0f911b8fee10ae531f91e391db3e74672a6";

  system = pkgs.stdenv.hostPlatform.system;
in

zoteroNixpkgs.legacyPackages.${system}.zotero
