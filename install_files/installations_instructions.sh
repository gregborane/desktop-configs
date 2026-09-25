# 1. Partition the disk
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 1GiB 100%

# 2. Hardened LUKS2 Container Creation
cryptsetup luksFormat /dev/nvme0n1p2 \
  --type luks2 \
  --cipher aes-xts-plain64 \
  --key-size 512 \
  --hash sha512 \
  --pbkdf argon2id \

# 3. Open LUKS Container
cryptsetup luksOpen /dev/nvme0n1p2 crypted

# 4. Create LVM Layout
pvcreate /dev/mapper/crypted
vgcreate vg0 /dev/mapper/crypted
lvcreate -L 8G -n swap vg0
lvcreate -l 100%FREE -n root vg0

# 5. Format Filesystems
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/vg0/root
mkswap -L swap /dev/vg0/swap

# 6. Mount Filesystems
mount /dev/vg0/root /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
swapon /dev/vg0/swap

# 7. Generate Initial NixOS Config
nixos-generate-config --root /mnt

# 8. Print UUID of the raw LUKS partition (Note this down!)
blkid -s UUID -o value /dev/nvme0n1p2
