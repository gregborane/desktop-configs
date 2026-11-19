
{
  flake.modules.nixos.power = { pkgs, ... }: {
    services.power-profiles-daemon.enable = false;

    services.tlp = {
      enable = true;

      settings = {
        TLP_DISABLE_DEFAULTS = 1;

        # AC: maximum performance
        CPU_DRIVER_OPMODE_ON_AC = "active";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_BOOST_ON_AC = 1;
        PLATFORM_PROFILE_ON_AC = "performance";

        # GPU: allow dynamic maximum clocks
        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";

        # Disable Wi-Fi power saving on AC
        WIFI_PWR_ON_AC = "off";

        # Battery: balanced / power saving
        CPU_DRIVER_OPMODE_ON_BAT = "active";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_BOOST_ON_BAT = 1;
        PLATFORM_PROFILE_ON_BAT = "balanced";

        RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
        WIFI_PWR_ON_BAT = "on";
      };
    };

    environment.systemPackages = with pkgs; [
      acpi
      acpid
      brightnessctl
    ];
  };
}

