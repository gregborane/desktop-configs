{
  flake.modules.nixos.gui-packages = { pkgs, ... }: {
    users.users.greg.packages = with pkgs; [
      qbittorrent
      localsend
      gimp
      file-roller
      loupe
      libsForQt5.qt5ct
      qt6Packages.qt6ct
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
