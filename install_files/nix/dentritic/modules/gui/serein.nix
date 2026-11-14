{ inputs, ... }:
{
  flake.modules.homeManager.serein =
    { pkgs, lib, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      home.packages = lib.optional (
        inputs.serein.packages ? ${system}.default
      ) inputs.serein.packages.${system}.default;
    };
}
