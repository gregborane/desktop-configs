{
  flake.modules.nixos.power = { pkgs, ... }: {
    services.power-profiles-daemon.enable = false;
    services.tlp = {
      enable = true;

      settings = {
        TLP_DISABLE_DEFAULTS = 1;

        CPU_DRIVER_OPMODE_ON_AC = "active";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_BOOST_ON_AC = 1;

        CPU_DRIVER_OPMODE_ON_BAT = "active";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_BOOST_ON_BAT = 1;
      };
    };
    environment.systemPackages = with pkgs; [
      acpi
      acpid
      brightnessctl
    ];
  };
}
