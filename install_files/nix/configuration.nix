{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./storage-configuration.nix
  ];


# ---------------------------------------------------------------------------
# Boot / kernel
# ---------------------------------------------------------------------------

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

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

  # -------------------------------------------------------------------------
  # Bootloader
  # -------------------------------------------------------------------------

  loader = {
    efi.canTouchEfiVariables = true;
    timeout = 5;

    systemd-boot = {
      enable = true;
      configurationLimit = 8;
      editor = false;
    };
  };

  # -------------------------------------------------------------------------
  # Initrd
  # -------------------------------------------------------------------------

  initrd = {
    systemd.enable = true;
    verbose = false;

    # LUKS devices and LVM are configured separately
    # in storage-configuration.nix.
  };

  # -------------------------------------------------------------------------
  # Plymouth
  # -------------------------------------------------------------------------

  plymouth = {
    enable = true;
    theme = "watch-dogs";

    themePackages = [
      (pkgs.runCommand "watch-dogs-plymouth-theme" { } ''
        themeDir="$out/share/plymouth/themes/watch-dogs"

        mkdir -p "$themeDir"
        cp -r ${../../config/watch-dogs}/. "$themeDir/"

        substituteInPlace "$themeDir/watch-dogs.plymouth" \
          --replace-fail \
          "/usr/share/plymouth/themes/watch-dogs" \
          "$themeDir"
      '')
     ];
    };
  };

  # ---------------------------------------------------------------------------
  # Memory / zram
  # ---------------------------------------------------------------------------

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 50;
    priority = 100;
  };

  # ---------------------------------------------------------------------------
  # CPU / power
  # ---------------------------------------------------------------------------

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

  # ---------------------------------------------------------------------------
  # Hardware
  # ---------------------------------------------------------------------------

  hardware = {
    bluetooth.enable = true;

    enableAllFirmware = true;

    graphics = {
      enable = true;
    };

    amdgpu.opencl.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------

  networking = {
    hostName = "xii";

    networkmanager = {
      enable = true;
      wifi.scanRandMacAddress = false;
    };

    firewall.enable = true;

    enableIPv6 = false;

    hosts = {
      "100.86.86.51" = [
        "greg-desktop"
      ];

      "100.110.31.78" = [
        "greg-phone"
      ];

      "100.118.211.88" = [
        "greg-initrd"
      ];
    };
  };

  # ---------------------------------------------------------------------------
  # Security
  # ---------------------------------------------------------------------------

  security.polkit.enable = true;

  # ---------------------------------------------------------------------------
  # Services
  # ---------------------------------------------------------------------------

  services = {
    gnome.gnome-keyring.enable = true;

    tailscale.enable = true;

    upower.enable = true;

    fprintd.enable = false;

    getty.autologinUser = "greg";

    fstrim.enable = true;

    printing.enable = true;

    pipewire = {
      enable = true;

      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;

          # Low-latency audio.
          "default.clock.quantum" = 128;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 256;
        };
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Locale / time
  # ---------------------------------------------------------------------------

  time.timeZone = "Canada/Eastern";

  # ---------------------------------------------------------------------------
  # Desktop
  # ---------------------------------------------------------------------------

  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    gamescope.enable = true;

    bash.completion.enable = true;

    nix-ld.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Fonts
  # ---------------------------------------------------------------------------

  fonts.packages = with pkgs; [
	  noto-fonts
		  noto-fonts-color-emoji
  ];

  # ---------------------------------------------------------------------------
  # Users
  # ---------------------------------------------------------------------------

  users.users.greg = {
    isNormalUser = true;

    extraGroups = [
      "networkmanager"
      "wheel"
      "rfkill"
      "audio"
      "pipewire"
      "video"
      "render"
    ];

    packages = with pkgs; [
      tree
    ];
  };

  # ---------------------------------------------------------------------------
  # Nixpkgs
  # ---------------------------------------------------------------------------

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ---------------------------------------------------------------------------
  # System packages
  # ---------------------------------------------------------------------------

  environment.systemPackages = with pkgs; [
    # Hardware / power
    acpi
    acpid
    brightnessctl

    # Development
    cargo
    cmake
    stdenv
    gnumake
    gcc
    pkg-config

    # Scientific / numerical computing
    sundials
    superlu
    eigen
    mkl
    hdf5

    # AMD ROCm
    rocmPackages.rocm-runtime
    rocmPackages.clr

    # Audio
    pipewire
    pipewire.jack
    alsa-plugins

    # Wayland / Hyprland
    hypridle
    hyprlock
    hyprshot
    wl-clipboard

    # Desktop / integration
    polkit_gnome
    libnotify
    kitty
    xdotool

    # Filesystems
    fuse3
    sshfs

    # Networking
    wget
    curl
    git
    wol
    openssl

    # Monitoring / filesystem utilities
    inotify-tools

    # Archives
    unrar
    rar
    p7zip
    unzip
    zip
    innoextract

    # Misc
    killall
    haskellPackages.gio
    nix-index
    appimage-run
  ];

  # ---------------------------------------------------------------------------
  # NixOS compatibility
  # ---------------------------------------------------------------------------

  # Do not change this merely when upgrading NixOS.
  system.stateVersion = "26.05";
}
