
{ inputs, ... }: {
  flake.modules.nixos.sway = { pkgs, ... }: 
    let
      unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
    xdg.portal = {
      enable = true;
      wlr.enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    programs.sway = {
      enable = true;
      package = unstable.swayfx;
      xwayland.enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [
        inputs.swaymonad.packages.${pkgs.stdenv.hostPlatform.system}.swaymonad
      ];
    };
  };
}

