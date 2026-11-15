{
  flake.modules.nixos.tui-packages = { lib, pkgs, ... }: {
    users.users.greg.packages =
      with pkgs;
      [
        lazygit
        sshs
        tmux
        ncdu
        bluetui
        wiremix
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [ btop-rocm ];
  };
}
