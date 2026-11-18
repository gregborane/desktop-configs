{inputs, ... }: {
  flake.modules.nixos.kernel = { pkgs, ... }:
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

        kernel.sysfs = {
          kernel.mm.transparent_hugepage = {
            enabled = "madvise";
            defrag = "defer";
            shmem_enabled = "within_size";
          };
        };

        zswap.enable = false;
      };
    };
}

