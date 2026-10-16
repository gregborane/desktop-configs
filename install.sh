#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# NixOS UEFI installation: two NVMe disks, both LUKS2 encrypted
#
# Disk 1: 1 GiB EFI + encrypted vg_system (root + 8 GiB swap)
# Disk 2: encrypted vg_home (home)
#
# WARNING: Erases existing partition tables, filesystems and
# access to data on BOTH selected disks.
# Run only from the NixOS installer, as root.
# ============================================================

DISK2=/dev/nvme0n1
DISK1=/dev/nvme1n1
SWAP_SIZE=8G

fail() { echo "ERROR: $*" >&2; exit 1; }

# Resolve /dev/disk/by-id/... paths if supplied above.
[[ $EUID -eq 0 ]] || fail "Run this script as root."
[[ -d /sys/firmware/efi ]] || fail "Boot the installer in UEFI mode."
mountpoint -q /mnt && fail "/mnt is already mounted; unmount it first."

for cmd in lsblk readlink wipefs parted partprobe udevadm cryptsetup \
           pvcreate vgcreate lvcreate mkfs.fat mkfs.ext4 mkswap \
           mount mountpoint swapon blkid nixos-generate-config sed grep findmnt vgs lvs; do
    command -v "$cmd" >/dev/null || fail "Missing command: $cmd"
done

[[ -b $DISK1 && -b $DISK2 ]] || fail "Both disk paths must exist."
DISK1=$(readlink -f -- "$DISK1")
DISK2=$(readlink -f -- "$DISK2")
[[ $DISK1 != "$DISK2" ]] || fail "The two disk paths resolve to the same device."

for disk in "$DISK1" "$DISK2"; do
    [[ $(lsblk -dn -o TYPE "$disk") == disk ]] || fail "$disk is not a whole disk."
    if lsblk -nr -o MOUNTPOINTS "$disk" | grep -q '[^[:space:]]'; then
        fail "$disk has mounted filesystems or active swap; unmount them first."
    fi
done

for name in crypted crypted_home; do
    [[ ! -e /dev/mapper/$name ]] || fail "/dev/mapper/$name already exists."
done
for name in vg_system vg_home; do
    if vgs "$name" >/dev/null 2>&1; then
        fail "LVM volume group $name already exists."
    fi
done

# Handle nvme0n1p1 as well as sda1 (including resolved by-id paths).
partition() {
    if [[ $1 == *[0-9] ]]; then
        printf '%sp%s' "$1" "$2"
    else
        printf '%s%s' "$1" "$2"
    fi
}

EFI_PART=$(partition "$DISK1" 1)
SYSTEM_PART=$(partition "$DISK1" 2)
HOME_PART=$(partition "$DISK2" 1)

printf '\n=== Selected disks — EVERYTHING ON BOTH WILL BE ERASED ===\n'
lsblk -o NAME,PATH,SIZE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS "$DISK1" "$DISK2"
printf '\nSystem disk: %s\nHome disk:   %s\n' "$DISK1" "$DISK2"
read -r -p 'Type ERASE to continue: ' confirmation
[[ $confirmation == ERASE ]] || fail "Aborted."

# 1. New partition tables
wipefs -af "$DISK1"
wipefs -af "$DISK2"

parted -s "$DISK1" mklabel gpt
parted -s "$DISK1" mkpart ESP fat32 1MiB 1GiB
parted -s "$DISK1" set 1 esp on
parted -s "$DISK1" mkpart primary 1GiB 100%

parted -s "$DISK2" mklabel gpt
parted -s "$DISK2" mkpart primary 1MiB 100%

partprobe "$DISK1" "$DISK2"
udevadm settle
[[ -b $EFI_PART && -b $SYSTEM_PART && -b $HOME_PART ]] || \
    fail "Expected partition nodes did not appear."

# 2. LUKS2: separate passwords/containers for system and home
for part in "$SYSTEM_PART" "$HOME_PART"; do
    cryptsetup luksFormat --type luks2 \
        --cipher aes-xts-plain64 \
        --key-size 512 \
        --hash sha512 \
        --pbkdf argon2id \
        "$part"
done

cryptsetup luksOpen "$SYSTEM_PART" crypted
cryptsetup luksOpen "$HOME_PART" crypted_home

# 3. Separate LVM volume groups for independent disks
pvcreate /dev/mapper/crypted
pvcreate /dev/mapper/crypted_home
vgcreate vg_system /dev/mapper/crypted
vgcreate vg_home /dev/mapper/crypted_home

lvcreate -L "$SWAP_SIZE" -n swap vg_system
lvcreate -l 100%FREE -n root vg_system
lvcreate -l 100%FREE -n home vg_home

# 4. Format
mkfs.fat -F 32 -n boot "$EFI_PART"
mkfs.ext4 -L nixos /dev/vg_system/root
mkfs.ext4 -L home /dev/vg_home/home
mkswap -L swap /dev/vg_system/swap

# 5. Mount
mount /dev/vg_system/root /mnt
mkdir -p /mnt/boot /mnt/home
mount -o umask=0077 "$EFI_PART" /mnt/boot
mount /dev/vg_home/home /mnt/home
swapon /dev/vg_system/swap

# 6. Generate default NixOS configuration
nixos-generate-config --root /mnt

# 7. Ensure BOTH LUKS devices are unlocked during early boot.
# The generator may miss LUKS layers underneath LVM.
SYSTEM_LUKS_UUID=$(blkid -s UUID -o value "$SYSTEM_PART")
HOME_LUKS_UUID=$(blkid -s UUID -o value "$HOME_PART")

STORAGE_CONFIG=/mnt/etc/nixos/storage-configuration.nix
MAIN_CONFIG=/mnt/etc/nixos/configuration.nix

cat > "$STORAGE_CONFIG" <<EOF
{ lib, ... }:
{
  # UEFI boot loader (the generated config may already set these).
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Explicit mappings: LUKS -> LVM -> ext4/swap.
  boot.initrd.luks.devices.crypted.device =
    lib.mkForce "/dev/disk/by-uuid/$SYSTEM_LUKS_UUID";
  boot.initrd.luks.devices.crypted_home.device =
    lib.mkForce "/dev/disk/by-uuid/$HOME_LUKS_UUID";

  boot.initrd.services.lvm.enable = true;

  # For LVM-on-LUKS with systemd-based stage 1 (NixOS 26.05+).
  fileSystems."/".options = [ "x-systemd.device-timeout=infinity" ];
}
EOF

if ! grep -Fq './hardware-configuration.nix' "$MAIN_CONFIG"; then
    fail "Could not locate hardware-configuration.nix import in $MAIN_CONFIG; import $STORAGE_CONFIG manually."
fi
# Add storage config within the existing Nix imports list.
sed -i 's|\./hardware-configuration\.nix|./hardware-configuration.nix\n    ./storage-configuration.nix|' "$MAIN_CONFIG"

# 8. Verification
printf '\n=== LUKS UUIDs ===\n'
printf 'System: %s\nHome:   %s\n' "$SYSTEM_LUKS_UUID" "$HOME_LUKS_UUID"
printf '\n=== Volume layout ===\n'
lsblk -f "$DISK1" "$DISK2"
lvs -o lv_name,vg_name,lv_size,devices
printf '\n=== Mounts ===\n'
findmnt /mnt
findmnt /mnt/boot
findmnt /mnt/home
printf '\nStorage preparation finished.\n'
printf 'Review %s and %s before installing.\n' "$MAIN_CONFIG" "$STORAGE_CONFIG"
printf 'Then run: nixos-install\n'
