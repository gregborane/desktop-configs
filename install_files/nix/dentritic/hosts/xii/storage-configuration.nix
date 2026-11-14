{ lib, ... }:
{
  # UEFI boot loader (the generated config may already set these).
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Explicit mappings: LUKS -> LVM -> ext4/swap.
  boot.initrd.luks.devices.crypted.device =
    lib.mkForce "/dev/disk/by-uuid/e5edf168-f394-4b10-a260-533541aa647c";
  boot.initrd.luks.devices.crypted_home.device =
    lib.mkForce "/dev/disk/by-uuid/a983eded-0906-4259-999f-1b906b7c28f4";

  boot.initrd.services.lvm.enable = true;

  # For LVM-on-LUKS with systemd-based stage 1 (NixOS 26.05+).
  fileSystems."/".options = [ "x-systemd.device-timeout=infinity" ];
}
