{ inputs, ... }:
{
  flake.modules.nixos.wine = { pkgs, lib, ... }:
    let
      unstable = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
      };
    in
    {
      users.users.greg.packages =
        [
          unstable.wineWow64Packages.stable
          unstable.winetricks
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
          (pkgs.wineasio.overrideAttrs (oldAttrs: {
            buildInputs = (oldAttrs.buildInputs or []) ++ [
              pkgs.pkgsi686Linux.pipewire.jack
              pkgs.pipewire.jack
            ];
          }))
        ];
    };
}
