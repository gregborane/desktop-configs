#!/bin/bash

set -e

# display manager
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
sudo apt modernize-sources
sudo apt update
sudo apt install zig

sudo mkdir -p /usr/share/wayland-sessions
sudo tee /usr/share/wayland-sessions/hyprland.desktop >/dev/null << "EOF"
[Desktop Entry]
Name=Hyprland
Comment=Hyprland Wayland Compositor
Exec=hyprland
Type=Application
DesktopNames=Hyprland
EOF

sudo apt -t unstable install libpam0g-dev libxcb-xkb-dev brightnessctl
mkdir -p $HOME/App && cd $HOME/App
git clone https://codeberg.org/fairyglade/ly.git
cd ly
zig build
zig build installexe -Dinit_system=systemd
