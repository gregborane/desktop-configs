{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
     kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
      "systemd.default_device_timeout_sec=infinity"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        theme = ../../../config/grub-themes/themes/weeb;
      };
    };
    initrd = {
        luks.devices.cryptroot = {
            device = "/dev/disk/by-uuid/6a1494e3-049e-4da6-9a3f-04aa715c55cc";
            crypttabExtraOpts = [
                "timeout=0"
            ];
        };
        
        systemd.enable = true;
        };

    plymouth = {
      enable = true;
      
      theme = "watch-dogs";
      themePackages = [
        (pkgs.runCommand "watch-dogs-plymouth-theme" { } ''
          themeDir="$out/share/plymouth/themes/watch-dogs"
          mkdir -p "$themeDir"
          cp -r ${../../../config/watch-dogs}/. "$themeDir/"

          substituteInPlace "$themeDir/watch-dogs.plymouth" \
            --replace-fail "/usr/share/plymouth/themes/watch-dogs" "$themeDir"
        '')
      ];
    }; 
  };

  # Enable necessary system features and daemons
  hardware.bluetooth.enable = true;

  networking.hostName = "xii";  
  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = false;
    };

  networking.firewall.enable = true;
  networking.enableIPv6  = false;
  networking.hosts = {
  "100.86.86.51" = [ "greg-desktop" ];
  "100.110.31.78" = [ "greg-phone" ];
  "100.118.211.88" = [ "greg-initrd" ];
   };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.tailscale = {
    enable = true;
  };
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services = {
    fprintd.enable = false;
    getty.autologinUser = "greg";
    fstrim.enable = true;
  };

  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pipewire = {
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
        "default.clock.quantum" = 128;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 256;
        };
    };
  };


  time.timeZone = "Canada/Eastern";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
     extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

  # Recommended for gamescope to get correct privileges
  programs.gamescope.enable = true;
  programs.bash.completion.enable = true;
  programs.nix-ld.enable = true;

  # Properly configuring fonts at the system level
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
  ];

  users.users.greg = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "rfkill" "audio" "pipewire" ];
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Kept strictly to core system / hardware utilities
  # All desktop apps and dev tools are now safely inside home.nix
  environment.systemPackages = with pkgs; [
    acpi acpid
    cargo cmake stdenv gnumake gcc
    brightnessctl killall
    pipewire pipewire.jack alsa-plugins
    haskellPackages.gio nix-index pkg-config fuse3
    hypridle hyprmon hyprlock hyprshot
    unrar rar p7zip unzip zip innoextract
    sundials superlu eigen mkl hdf5
    inotify-tools polkit_gnome libnotify kitty xdotool
    wget wol openssl sshfs git curl
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.11";
}
