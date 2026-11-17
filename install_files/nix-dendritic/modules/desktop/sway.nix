
{ inputs, ... }: {
  flake.modules.nixos.sway = { pkgs, lib, ... }:

    let
      swayPackage = pkgs.sway.override (prev: {
        sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
          patches =
            builtins.filter
              (patch:
                !(builtins.elem (builtins.baseNameOf (toString patch)) [
                  "sway-config-nixos-paths.patch"
                  "sway-config-no-nix-store-references.patch"
                ])
              )
              old.patches
            ++ [
              (pkgs.path + "/pkgs/by-name/sw/sway-unwrapped/sway-config-no-nix-store-references.patch")
            ];
        });
      });
    in
    {
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      programs.sway = {
        enable = true;
        package = swayPackage;

        extraPackages = lib.mkForce [
          inputs.swaymonad.packages.${pkgs.stdenv.hostPlatform.system}.swaymonad
        ];

        xwayland.enable = true;
        wrapperFeatures.gtk = true;
      };

      programs.bash.loginShellInit = lib.mkAfter ''
        if [ -n "$BASH_VERSION" ] && [ "$USER" = greg ]; then
          export QT_QPA_PLATFORMTHEME=qt6ct
          export QT_QPA_PLATFORM=wayland
          export GDK_BACKEND='wayland,x11,*'
          export SDL_VIDEODRIVER=wayland,x11
          export MOZ_ENABLE_WAYLAND=1
          export ELECTRON_OZONE_PLATFORM_HINT=wayland
          export OZONE_PLATFORM=wayland

          if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec sway
          fi
        fi
      '';
    };
}

