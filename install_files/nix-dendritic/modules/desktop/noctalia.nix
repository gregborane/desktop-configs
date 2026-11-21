{ inputs, ... }: {
  flake.modules.nixos.noctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      assets = ../../../../config/noctalia;
      settings = assets + "/noctalia-full-config.toml";
    in
    {
      imports = [ inputs.noctalia.nixosModules.default ];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };
    };
  }
