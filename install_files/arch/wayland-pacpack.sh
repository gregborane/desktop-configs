#!/bin/bash

set -e

# Update existing packages
sudo pacman -Syu

# Core and utilities
sudo pacman -S --noconfirm --needed alsa-plugins aspell atril
sudo pacman -S --noconfirm --needed base base-devel bash-completion biber
sudo pacman -S --noconfirm --needed cmake composer curl chromium
sudo pacman -S --noconfirm --needed dkms 
sudo pacman -S --noconfirm --needed eza
sudo pacman -S --noconfirm --needed fastfetch fd firewalld feh ffmpeg fontconfig fuse-common fzf
sudo pacman -S --noconfirm --needed gamescope gimp gnome-keyring ghostscript ghostty git gtk3 gtk4
sudo pacman -S --noconfirm --needed hdf5 hspell htop
sudo pacman -S --noconfirm --needed imagemagick
sudo pacman -S --noconfirm --needed jdk-openjdk julia
# sudo pacman -S --noconfirm --needed k
sudo pacman -S --noconfirm --needed lazygit less libreoffice-fresh luarocks lutris
sudo pacman -S --noconfirm --needed mako mariadb mermaid-cli
sudo pacman -S --noconfirm --needed ncurses nemo neovim ninja noto-fonts-emoji noto-fonts noto-fonts-cjk nuspell nwg-look
sudo pacman -S --noconfirm --needed obs-studio openal openssh
sudo pacman -S --noconfirm --needed pavucontrol polkit-gnome php python-neovim plymouth
sudo pacman -S --noconfirm --needed qt5 qt6
sudo pacman -S --noconfirm --needed r ripgrep ruby
sudo pacman -S --noconfirm --needed sqlite sshfs steam starship stylua swaybg swayosd
sudo pacman -S --noconfirm --needed tectonic texlive timeshift tree-sitter-cli thunderbird
sudo pacman -S --noconfirm --needed ueberzugpp ufw upower unzip
sudo pacman -S --noconfirm --needed vlc vlc-plugin-ffmpeg
sudo pacman -S --noconfirm --needed waybar wget wine-gecko wine-mono wine-staging wofi
sudo pacman -S --noconfirm --needed xdotool xorg-xhost
#sudo pacman -S --noconfirm --needed y
sudo pacman -S --noconfirm --needed zathura zip zoxide

# Libraries — include X11-related ones only as needed for Wine
sudo pacman -S --noconfirm --needed \
lib32-alsa-lib lib32-alsa-plugins lib32-giflib lib32-gmp lib32-gnutls \
lib32-libgpg-error lib32-libjpeg-turbo lib32-libldap lib32-libpulse \
lib32-libxcomposite lib32-libxinerama lib32-libxslt lib32-mpg123 lib32-ncurses \
lib32-opencl-icd-loader lib32-sqlite libgcrypt libgpg-error libjpeg-turbo \
libldap libpng libxcomposite libxinerama libxslt libva v4l-utils \
winetricks protontricks

# Vulkan support for AMD, Intel, and NVIDIA
sudo pacman -S --noconfirm --needed \
vulkan-icd-loader vulkan-headers vulkan-tools vulkan-validation-layers \
mesa vulkan-radeon vulkan-intel \
lib32-mesa lib32-vulkan-radeon lib32-vulkan-intel \
lib32-vulkan-icd-loader lib32-vulkan-validation-layers

