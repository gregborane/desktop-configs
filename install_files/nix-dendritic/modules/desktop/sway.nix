
{ inputs, ... }: {
  flake.modules.nixos.sway = { pkgs, ... }: {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    programs.swayfx = {
      enable = true;
      xwayland.enable = true;
      wrapperFeatures.gtk = true;
      #extraPackages = [ inputs.swaymonad.packages.${pkgs.stdenv.hostPlatform.system}.swaymonad ];
    };
  };

  flake.modules.homeManager.sway = { lib, ... }: {
    programs.bash.profileExtra = lib.mkAfter ''
      export QT_QPA_PLATFORMTHEME=qt6ct
      export QT_QPA_PLATFORM=wayland

      export GDK_BACKEND=wayland,x11,*

      export SDL_VIDEODRIVER=wayland,x11

      export MOZ_ENABLE_WAYLAND=1

      export ELECTRON_OZONE_PLATFORM_HINT=wayland
      export OZONE_PLATFORM=wayland

      # export LIBVA_DRIVER_NAME=nvidia
      # export __GLX_VENDOR_LIBRARY_NAME=nvidia

      if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
  };
}
