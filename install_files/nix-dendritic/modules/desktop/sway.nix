
{ inputs, ... }: {
  flake.modules.nixos.sway = { pkgs, ... }: 
    let
      stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
      package = stable.sway;
      xwayland.enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [
        inputs.swaymonad.packages.${pkgs.stdenv.hostPlatform.system}.swaymonad
      ];
    };
  };
}

