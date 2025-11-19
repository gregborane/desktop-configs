#!/bin/bash

# Update existing packages
sudo pacman -Syu

# Dependencies for my System
sudo pacman -S --noconfirm --needed ghostty aspell atril
sudo pacman -S --noconfirm --needed base-devel bash-completion biber
sudo pacman -S --noconfirm --needed cmake composer curl
sudo pacman -S --noconfirm --needed dkms dotnet-runtime-7.0 dotnet-runtime-8.0
#sudo pacman -S --nocnfirm --needed e
sudo pacman -S --noconfirm --needed ffmpeg fontconfig fuse-common fzf
sudo pacman -S --noconfirm --needed gamescope gamemode gimp giflip gnome-text-editor ghostscript git gtk3 gtk4
sudo pacman -S --noconfirm --needed hdf5 hspell htop
sudo pacman -S --noconfirm --needed imagemagick
sudo pacman -S --noconfirm --needed jdk-openjdk julia
#sudo pacman -S --noconfirm --needed k
sudo pacman -S --noconfirm --needed less libreoffice-fresh luarocks lutris
sudo pacman -S --noconfirm --needed mariadb mermaid-cli
sudo pacman -S --noconfirm --needed ncurses neovim ninja noto-fonts-emoji nuspell nwg-look
sudo pacman -S --noconfirm --needed obs-studio openal openssh
sudo pacman -S --noconfirm --needed pavucontrol php python-neovim
sudo pacman -S --noconfirm --needed qt5 qt6
sudo pacman -S --noconfirm --needed r ripgrep ruby
sudo pacman -S --noconfirm --needed sqlite sshfs steam starship
sudo pacman -S --noconfirm --needed tectonic texlive thunar timeshift tree-sitter-cli thunderbird
sudo pacman -S --noconfirm --needed ueberzugpp upower unzip
sudo pacman -S --noconfirm --needed vlc vlc-plugin-ffmpeg
sudo pacman -S --noconfirm --needed wget wine-staging
#sudo pacman -S --noconfirm --needed x
sudo pacman -S --noconfirm --needed yay
sudo pacman -S --noconfirm --needed zathura zip zoxide

# lib* packages (alphabetically sorted)
sudo pacman -S --noconfirm --needed lib32-alsa-lib lib32-alsa-plugins lib32-giflib lib32-gmp lib32-gnutls \
lib32-libgpg-error lib32-libjpeg-turbo lib32-libldap lib32-libpulse lib32-libxcomposite lib32-libxinerama \
lib32-libxslt lib32-mpg123 lib32-ncurses lib32-opencl-icd-loader lib32-sqlite libgcrypt libgpg-error \
libjpeg-turbo libldap libpng libxcomposite libxinerama libxslt libva v4l-utils

# Vulkan support for AMD, Intel, and NVIDIA
sudo pacman -S --noconfirm --needed \
vulkan-icd-loader vulkan-tools vulkan-validation-layers \
mesa vulkan-radeon vulkan-intel vulkan-nouveau \
lib32-mesa lib32-vulkan-radeon lib32-vulkan-intel lib32-vulkan-nouveau \
lib32-vulkan-icd-loader lib32-vulkan-validation-layers
