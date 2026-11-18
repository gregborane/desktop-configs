{
  flake.modules.nixos.amd = { pkgs, ... }: {
    networking = {
        hostName = "xii";

        networkmanager = {
          enable = true;
          wifi.scanRandMacAddress = false;
        };

        firewall.enable = true;

        enableIPv6 = false;

        hosts = {
          "100.86.86.51" = [
            "greg-desktop"
          ];

          "100.110.31.78" = [
            "greg-phone"
          ];

          "100.118.211.88" = [
            "greg-initrd"
          ];
        };
    }
  };
}

