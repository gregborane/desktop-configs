{ inputs, self, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      cfg = self.nixosConfigurations.xii.config;
      pinnedZotero = inputs.zotero-nixpkgs.legacyPackages.${system}.zotero;
      optionalDesktop = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          self.modules.nixos.hyprland
          {
            nixpkgs.hostPlatform = system;
            system.stateVersion = "26.05";
          }
        ];
      };
      linuxSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      root = ../../../..;
    in
    {
      formatter = pkgs.nixfmt;
      checks = {
        formatting = pkgs.runCommand "check-nix-format" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
          find ${../..} -name '*.nix' ! -name hardware-configuration.nix ! -name storage-configuration.nix -exec nixfmt --check {} +
          touch "$out"
        '';
        inherit (self.packages.${system}) omnisearch;
        configuration =
          assert builtins.attrNames self.formatter == linuxSystems;
          assert builtins.attrNames self.packages == linuxSystems;
          assert builtins.attrNames self.checks == linuxSystems;
          assert optionalDesktop.config.programs.hyprland.enable;
          assert optionalDesktop.config.programs.hyprland.xwayland.enable;
          assert !optionalDesktop.config.programs.uwsm.enable;
          assert pinnedZotero.version == "10.0.2";
          assert inputs.zotero-nixpkgs.rev == "131cf0f911b8fee10ae531f91e391db3e74672a6";
          assert builtins.all (p: builtins.pathExists (root + p)) [
            "/config/noctalia/noctalia-full-config.toml"
            "/config/watch-dogs/watch-dogs.plymouth"
            "/config/sway/config"
            "/local/bash/rc"
          ];
          pkgs.runCommand "check-linux-configuration" { } "touch $out";
      }
      // pkgs.lib.optionalAttrs (system == "aarch64-linux") {
        home-packages =
          let
            profile = inputs.nixpkgs.lib.nixosSystem {
              modules =
                (with self.modules.nixos; [
                  greg
                  cli-packages
                  gui-packages
                  desktop-packages
                  tui-packages
                  development-packages
                  neovim
                  zotero
                  ns
                  wine
                  thunar
                  ghostty
                  serein
                  zapfast
                ])
                ++ [
                  {
                    nixpkgs.hostPlatform = system;
                    nixpkgs.config.allowUnfree = true;
                  }
                ];
            };
          in
          assert builtins.all (
            p: pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform p
          ) profile.config.users.users.greg.packages;
          pkgs.runCommand "check-arm-home-packages" { } "touch $out";
      }
      // pkgs.lib.optionalAttrs (system == "x86_64-linux") {
        xii =
          assert cfg.programs.sway.enable && cfg.programs.sway.xwayland.enable;
          assert !cfg.programs.hyprland.enable;
          assert !(cfg.systemd.services ? home-manager-greg);
          assert cfg.systemd.user.services.noctalia.environment.NOCTALIA_CONFIG_HOME == "/etc/xdg";
          assert
            cfg.services.omnisearch.enable
            &&
              cfg.services.omnisearch.settings.server == {
                host = "127.0.0.1";
                port = 8087;
              };
          assert cfg.programs.noctalia.enable && cfg.programs.git.lfs.enable;
          assert builtins.any (p: p.name == pinnedZotero.name) cfg.users.users.greg.packages;
          assert cfg.system.stateVersion == "26.05";
          cfg.system.build.toplevel;
      };
    };
}
