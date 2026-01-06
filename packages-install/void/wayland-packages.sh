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
sudo xbps-install hdf5 htop
sudo xbps-install imagemagick
sudo xbps-install openjdk openjdk-common juliaup
# sudo xbps-install k
sudo xbps-install lazygit less libreoffice-fresh linux-lts linux-lts-docs linux-lts-headers luarocks lutris
sudo xbps-install mako mariadb
sudo xbps-install ncurses neovim ninja noto-fonts-ttf noto-fonts-emojis noto-fonts-cjk-sans nuspell
sudo xbps-install obs libopenal
sudo xbps-install pavucontrol polkit-gnome php python3-neovim plymouth
sudo xbps-install qt5 qt5
sudo xbps-install r ripgrep ruby
sudo xbps-install sqlite libssh starship StyLua
sudo xbps-install tectonic texlive thunar timeshift tree-sitter thunderbird
sudo xbps-install ufw upower unzip
sudo xbps-install vlc libvlc 
sudo xbps-install waybar wget wine wine-gecko wine-mono wine-tools protontricks wineasio winetricks wofi
sudo xbps-install xdotool 
# sudo xbps-install y
sudo xbps-install zathura zip zoxide
