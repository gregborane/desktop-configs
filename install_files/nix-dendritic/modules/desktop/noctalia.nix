{ inputs, ... }: {
  flake.modules.nixos.noctalia =
    {config, lib, pkgs, ...}:
    programs.noctalia = {
    enable = false;
    systemd.enable = false;
    settings = ../../config/noctalia/noctalia-full-config.toml;
  };
}
