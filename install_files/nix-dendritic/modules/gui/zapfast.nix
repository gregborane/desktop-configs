
{ inputs, ... }: {
  flake.modules.nixos.zapfast = { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
    in
    {
      users.users.greg.packages = [
        (inputs.zapfast.packages.${system}.default.overrideAttrs (old: {
          buildInputs = (old.buildInputs or []) ++ [
            unstable.openssl
            unstable.sqlcipher
          ];
        }))
      ];
    };
}

