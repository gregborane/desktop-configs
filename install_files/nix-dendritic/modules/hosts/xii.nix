{ inputs, config, ... }:
{
  flake.nixosConfigurations.xii = inputs.nixpkgs.lib.nixosSystem {
    modules =
      (with config.flake.modules.nixos; [
        xii-boot
        power
        amd
        bluetooth
        audio
        polkit
        ssh
        tailscale
        integration
        nix
        fonts
        sway
        bash
        git
        cli-packages
        desktop-packages
        development-packages
        chromium
        omnisearch
        greg
      ])
      ++ [
        ../../hosts/xii/hardware-configuration.nix
        ../../hosts/xii/storage-configuration.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users.greg.imports = [ config.flake.modules.homeManager.greg ];
          };
          services.omnisearch = {
            enable = true;
            settings.server = {
              host = "127.0.0.1";
              port = 8087;
            };
          };
          services.openssh.settings.AllowUsers = [ "greg" ];
          services.getty.autologinUser = "greg";
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
          };
          time.timeZone = "Canada/Eastern";
          system.stateVersion = "26.05";
        }
      ];
  };
}
