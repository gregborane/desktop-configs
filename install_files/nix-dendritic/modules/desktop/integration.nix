{
  flake.modules.nixos.integration = {
    services = {
      gnome.gnome-keyring.enable = true;

      udisks2.enable = true;
      upower.enable = true;

      fprintd.enable = false;
      fstrim.enable = true;

      gvfs.enable = true;

      tumbler.enable = true;

      printing.enable = true;
    };
  };
}
