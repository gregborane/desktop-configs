{
  flake.modules.nixos.desktop-packages = { pkgs, ... }: {
    programs.gamescope.enable = true;
    environment.systemPackages = with pkgs; [
      wl-clipboard
      xfconf
      libnotify
      kitty
      xdotool
    ];
    users.users.greg.packages = with pkgs; [
      adw-gtk3
      nwg-look
      gsettings-desktop-schemas
      wofi
    ];
  };
}
