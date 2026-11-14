{
  flake.modules.homeManager.tui-packages = { lib, pkgs, ... }: {
    home.packages =
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
