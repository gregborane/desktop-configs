{
  flake.modules.nixos.amd = { pkgs, ... }: {
    hardware.enableAllFirmware = true;

    hardware.graphics = {
      enable = true;
    };

    hardware.amdgpu.opencl.enable = true;
    environment.systemPackages = with pkgs; [
      rocmPackages.rocm-runtime
      rocmPackages.clr
      rocmPackages.rocm-smi
    ];
  };
}
