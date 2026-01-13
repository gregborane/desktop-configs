#!/bin/bash

set -e

# update existing 

xbps-install -Syu

sudo xbps-install alsa-plugins aspell atril
sudo xbps-install bash-completion biber
sudo xbps-install cmake composer curl chromium
sudo xbps-install dkms
sudo xbps-install eza
sudo xbps-install fastfetch fd feh ffmpeg fontconfig fuse fzf
sudo xbps-install gamescope gimp ghostty git gtk+3 gtk+4 gnome-keyring
sudo xbps-install hdf5 htop hyprutils
sudo xbps-install imagemagick
sudo xbps-install openjdk openjdk-common juliaup
# sudo xbps-install k
sudo xbps-install lazygit less libreoffice-fresh linux-lts linux-lts-docs linux-lts-headers luarocks lutris
sudo xbps-install mako mariadb
sudo xbps-install ncurses nvidia neovim ninja noto-fonts-ttf noto-fonts-emojis noto-fonts-cjk-sans nuspell NetworkManager
sudo xbps-install obs openssh libopenal
sudo xbps-install pavucontrol polkit-gnome php python3-neovim plymouth protontricks
sudo xbps-install qt5 qt6 qbittorrent
sudo xbps-install r ripgrep ruby
sudo xbps-install sqlite starship StyLua
sudo xbps-install tectonic texlive thunar timeshift tree-sitter thunderbird
sudo xbps-install ufw upower unzip
sudo xbps-install vlc libvlc 
sudo xbps-install waybar wiremix wget wine wine-gecko wine-mono wine-tools wineasio winetricks wofi wayland
sudo xbps-install xdotool xorg-server-xwayland
# sudo xbps-install y
sudo xbps-install zathura zip zoxide

sudo xbps-install Vulkan-Headers Vulkan-Tools Vulkan-Utility-Libraries Vulkan-Utility-Libraries-32bit	Vulkan-ValidationLayers Vulkan-ValidationLayers-32bit vulkan-loader vulkan-loader-32bit
