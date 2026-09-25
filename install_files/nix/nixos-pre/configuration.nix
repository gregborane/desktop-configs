{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

 
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
    };
    initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/6a1494e3-049e-4da6-9a3f-04aa715c55cc";
    initrd.systemd.enable = true;
    plymouth.enable = true;
  };

  services = {
    fprintd.enable = false;
    getty.autologinUser = "greg";
    fstrim.enable = true;
    };

  networking.hostName = "xii";  
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  time.timeZone = "America/Los_Angeles";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  fonts.packages = with pkgs; [
  nerd-fonts.fira-code
	];

  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.greg = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "rfkill"  "realtime"];
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    chromium
    wget
    ghostty
    quickshell
    kitty
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

}
