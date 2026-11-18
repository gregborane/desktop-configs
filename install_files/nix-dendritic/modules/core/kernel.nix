{
  flake.module.nixos.kernel = { inputs, pkgs, ... }:
    let
      small = inputs.nixpkgs-small.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      boot = {
        kernelPackages = small.linuxPackages_latest;

        kernelParams = [
          "quiet"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
          "preempt=lazy"
        ];

        zswap.enable = false;
      };
    };
}

