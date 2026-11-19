
{ inputs, ... }: {
  flake.modules.nixos.sway = { pkgs, ... }: {
    xdg.portal = {
      enable = true;
      wlr.enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    programs.sway = {
      enable = true;
      xwayland.enable = true;

      package = pkgs.sway.override {
        sway-unwrapped =
          inputs.swayfx.packages.${pkgs.stdenv.hostPlatform.system}.swayfx-unwrapped-git;
      };

      wrapperFeatures.gtk = true;

      extraPackages = [
        inputs.swaymonad.packages.${pkgs.stdenv.hostPlatform.system}.swaymonad
      ];
    };
  };
}

