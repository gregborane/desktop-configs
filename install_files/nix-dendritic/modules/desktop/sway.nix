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
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
      extraPackages = [ inputs.swaymonad.packages.${pkgs.stdenv.hostPlatform.system}.swaymonad ];
    };
  };
}
