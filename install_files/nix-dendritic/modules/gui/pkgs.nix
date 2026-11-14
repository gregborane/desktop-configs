{
  flake.modules.homeManager.gui-packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      qbittorrent
      localsend
      gimp
      loupe
      obs-studio
      thunderbird
      vlc
      zathura
      gnome-disk-utility
      lutris
      qjackctl
    ];
  };
}
