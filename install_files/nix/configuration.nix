{ pkgs, config, ... }:

let
  # dwl runs -s after creating the Wayland socket and setting DISPLAY for XWayland.
  ready = pkgs.writeShellScript "xii-dwl-ready" ''
    set -eu
    vars=(WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE XCURSOR_THEME XCURSOR_SIZE PATH)
    for name in DISPLAY XDG_SESSION_ID XDG_SEAT XDG_VTNR QT_QPA_PLATFORMTHEME QT_QPA_PLATFORM GDK_BACKEND SDL_VIDEODRIVER MOZ_ENABLE_WAYLAND ELECTRON_OZONE_PLATFORM_HINT OZONE_PLATFORM; do
      if [[ -v $name ]]; then vars+=("$name"); fi
    done
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd "''${vars[@]}"
    ${pkgs.systemd}/bin/systemctl --user start dwl-session.target
    ${pkgs.systemd}/bin/systemctl --user try-restart xdg-desktop-portal-wlr.service xdg-desktop-portal-gtk.service xdg-desktop-portal.service
    # dwl sends SIGTERM to this process group during normal teardown.
    exec ${pkgs.coreutils}/bin/cat >/dev/null
  '';

  session = pkgs.writeShellScriptBin "xii-dwl" ''
    set -eu
    export XDG_CURRENT_DESKTOP=dwl XDG_SESSION_DESKTOP=dwl XDG_SESSION_TYPE=wayland
    export XCURSOR_THEME=Bibata-Modern-Ice XCURSOR_SIZE=24
    export WLR_XWAYLAND=${pkgs.xwayland}/bin/Xwayland
    ctl=${pkgs.systemd}/bin/systemctl
    cleanup() {
      "$ctl" --user stop dwl-session.target || :
      "$ctl" --user unset-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_SESSION_ID || :
    }
    trap cleanup EXIT
    # End any units left over from an abruptly terminated tty1 login.
    "$ctl" --user stop dwl-session.target
    "${config.programs.dwl.package}/bin/dwl" -s "exec ${ready}"
  '';
in
{
  imports = [
    ./hardware-configuration.nix
    ./storage-configuration.nix
    ./browser.nix
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
    
  services.openssh = {
        enable = false;
        openFirewall = true;
        settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "greg" ];
        MaxAuthTries = 3;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
        };
  };
  
  services = {
    gnome.gnome-keyring.enable = true;

    udisks2.enable = true;
    
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
    wlr.enable = true;
    config.dwl = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs = {
    dwl = {
      enable = true;
      package = assert pkgs.dwl.version == "0.8";
        (pkgs.dwl.override {
          configH = ../../config/dwl/dwl-config.h;
          enableXWayland = true;
        }).overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ../../config/dwl/dwl-0.8-xii.patch ];
        });
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
    session
    xdg-utils

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
    rocmPackages.rocm-smi

    # Audio
    pipewire
    pipewire.jack
    alsa-plugins

    # Wayland clipboard
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
