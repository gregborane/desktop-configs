{ inputs, config, ... }:
{
  flake.nixosConfigurations.xii = inputs.nixpkgs.lib.nixosSystem {
    modules =
      (with config.flake.modules.nixos; [
        bash
        git
        ns
        cli-packages

        nix

        fonts
        hyprland
        integration
        noctalia 
        desktop-packages
        sway
        theming

        chromium
        ghostty
        gui-packages
        serein
        thunar
        wine 
        zapfast
        zotero


        amd
        audio
        bluetooth
        power
        xii-boot

        omnisearch
        polkit
        ssh
        tailscale

        neovim
        tui-packages

        greg
         ])
      ++ [
        ../../hosts/xii/hardware-configuration.nix
        ../../hosts/xii/storage-configuration.nix
        {
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
