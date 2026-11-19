
{ inputs, ... }: {
  flake.modules.nixos.zotero = { pkgs, ... }:
    let
      unstable = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "firefox-esr-140-bin-unwrapped-140.17.0esr"
          ];
        };
      };
    in
    {
      users.users.greg.packages = [
        unstable.zotero
      ];
    };
}

