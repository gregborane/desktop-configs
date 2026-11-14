{ inputs, self, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      cfg = self.nixosConfigurations.xii.config;
      home = cfg.home-manager.users.greg;
      zotero = inputs.zotero-nixpkgs.legacyPackages.${system}.zotero;
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
      root = ../../../../..;
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
          assert zotero.version == "10.0.2";
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
            profile = inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
              modules = [ self.modules.homeManager.greg ];
            };
          in
          assert builtins.all (
            p: pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform p
          ) profile.config.home.packages;
          pkgs.runCommand "check-arm-home-packages" { } "touch $out";
      }
      // pkgs.lib.optionalAttrs (system == "x86_64-linux") {
        xii =
          assert cfg.programs.sway.enable && cfg.programs.sway.xwayland.enable;
          assert !cfg.programs.hyprland.enable;
          assert
            cfg.services.omnisearch.enable
            &&
              cfg.services.omnisearch.settings.server == {
                host = "127.0.0.1";
                port = 8087;
              };
          assert home.programs.noctalia.enable && home.programs.neovim.enable && home.programs.git.lfs.enable;
          assert builtins.elem zotero home.home.packages;
          assert cfg.system.stateVersion == "26.05" && home.home.stateVersion == "26.05";
          cfg.system.build.toplevel;
      };
    };
}
