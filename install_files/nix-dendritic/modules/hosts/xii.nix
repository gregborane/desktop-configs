{ inputs, config, ... }:
{
  flake.nixosConfigurations.xii = inputs.nixpkgs.lib.nixosSystem {
    modules =
      (with config.flake.modules.nixos; [
        bash
        git
        ns
        cli-packages

        kernel
        nix

        development-packages

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
        network
        power
        xii-boot

        getty
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
          time.timeZone = "Canada/Eastern";
        }
      ];
  };
}
