
{ inputs, ... }: {
  flake.modules.nixos.sway = { pkgs, ... }: 
    let
      channel = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
      package = channel.swayfx;
      xwayland.enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [
        inputs.swaymonad.packages.${pkgs.stdenv.hostPlatform.system}.swaymonad
      ];
    };
  };
}

