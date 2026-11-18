{
  flake.modules.nixos.xii-boot = { pkgs, ... }: {
    boot = {
      
      # -------------------------------------------------------------------------
      # Bootloader
      # -------------------------------------------------------------------------

      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 5;

        systemd-boot = {
          enable = true;
          configurationLimit = 8;
          editor = false;
        };
      };

      # -------------------------------------------------------------------------
      # Initrd
      # -------------------------------------------------------------------------

      initrd = {
        systemd.enable = true;
        verbose = false;

        # LUKS devices and LVM are configured separately
        # in storage-configuration.nix.
      };

      # -------------------------------------------------------------------------
      # Plymouth
      # -------------------------------------------------------------------------

      plymouth = {
        enable = true;
        theme = "watch-dogs";

        themePackages = [
          (pkgs.runCommand "watch-dogs-plymouth-theme" { } ''
            themeDir="$out/share/plymouth/themes/watch-dogs"

            mkdir -p "$themeDir"
            cp -r ${../../../../config/watch-dogs}/. "$themeDir/"

            substituteInPlace "$themeDir/watch-dogs.plymouth" \
              --replace-fail \
              "/usr/share/plymouth/themes/watch-dogs" \
              "$themeDir"
          '')
        ];
      };
    };
    zramSwap = {
      enable = true;
      algorithm = "lz4";
      memoryPercent = 50;
      priority = 100;
    };
  };
}
