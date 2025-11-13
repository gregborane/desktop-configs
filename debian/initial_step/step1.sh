#!/bin/bash

set -e

# base system
sudo apt update

sudo apt install -y debian-archive-keyring build-essential\
 cmake linux-headers-$(uname -r) firmware-linux firmware-linux-free firmware-linux-nonfree\
 firmware-misc-nonfree network-manager systemd systemd-sysv bash-completion ca-certificates\
 curl wget gnupg apt-transport-https lsb-release pciutils usbutils lsof psmisc net-tools iproute2\
 iputils-ping dnsutils ethtool ufw vim-tiny less man-db manpages manpages-dev rsync tar xz-utils zip\
 unzip bzip2 gzip file coreutils findutils grep sed make git logrotate cron locales console-setup\
 kbd tzdata initramfs-tools libpam-systemd dbus udev acpid haveged rng-tools gcc make acpid dkms pkg-config

# add unstable
curl -fsSL https://ftp-master.debian.org/keys/archive-key-12.asc | gpg --dearmor | sudo tee /usr/share/keyrings/debian-archive-keyring.gpg > /dev/null
sudo tee /etc/apt/apt.conf.d/20-tum.conf >/dev/null <<"EOF"
APT::Default-Release "/^testing(|-security|-updates)$/";
EOF

sudo tee /etc/apt/sources.list >/dev/null <<"EOF"
deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] https://deb.debian.org/debian testing main contrib non-free non-free-firmware
deb [signed-by=/usr/share/keyrings/debian-archive-keyring.gpg] https://deb.debian.org/debian unstable main contrib non-free non-free-firmware
EOF

sudo apt modernize-sources

# graphical interface
sudo apt update
sudo apt -t unstable install -y hypr* wayland-protocols libglvnd-dev libgl1-mesa-dev libegl1-mesa-dev libvulkan1 libvulkan-dev vulkan-tools vulkan-validationlayers libvulkan-volk-dev libwayland-bin libwayland-dev xwayland mesa-utils mesa-vulkan-drivers libinput10 libseat1 seatd udev dbus xdg-desktop-portal xdg-desktop-portal-hyprland mako-notifier wofi polkitd 
