{ inputs, ... }:
{
  flake.modules.nixos.serein =
    { pkgs, lib, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      users.users.greg.packages = lib.optional (
        inputs.serein.packages ? ${system}.default
      ) inputs.serein.packages.${system}.default;
    };
}
