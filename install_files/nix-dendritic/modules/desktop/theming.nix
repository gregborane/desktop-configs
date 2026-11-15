{
  flake.modules.nixos.theming = {
    programs = {
      xfconf.enable = true;
      dconf = {
        enable = true;
        profiles.user.databases= [
            {
                lockAll = false;
                settings = {
                "org/gnome/desktop/interface" = {
                    gtk-theme = "adw-gtk3-dark";
                    icon-theme = "WhiteSur-dark";
                    color-scheme = "prefer-dark";
                    cursor-theme = "Bibata-Modern-Ice";
                    };
                };
            }
        ];
      };
    };
  };
}
