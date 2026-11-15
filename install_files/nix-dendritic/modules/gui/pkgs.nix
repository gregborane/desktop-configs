{
  flake.modules.nixos.gui-packages = { pkgs, ... }: {
    users.users.greg.packages = with pkgs; [
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
