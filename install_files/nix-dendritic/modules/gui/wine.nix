{
  flake.modules.nixos.wine = { pkgs, lib, ... }: {
    users.users.greg.packages =
      with pkgs;
      [

      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
        wineWow64Packages.stable
        winetricks
        (wineasio.overrideAttrs {
          buildInputs = [
            pkgsi686Linux.pipewire.jack
            pipewire.jack
          ];
        })
      ];
  };
}
