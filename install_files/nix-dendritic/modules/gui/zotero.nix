{ inputs, ... }: {
  flake.modules.nixos.zotero = { pkgs, ... }:
    let
      unstable = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    in
    {
      users.users.greg.packages = [
        unstable.zotero
      ];
    };
}
