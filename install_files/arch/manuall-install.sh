#!/bin/bash

sudo pacman -S zig
LY="$HOME/.local/share/ly"
CONFIG="$HOME/.config/desktop-config/config"
git clone https://codeberg.org/fairyglade/ly.git "$LY"
cd "$LY"
zig build
sudo zig build installexe -Dinit_system=systemd
sudo systemctl disable lightdm.service
sudo systemctl enable ly@tty2.service
sudo systemctl disable getty@tty2.service
sudo ln -s "$HOME/.config/desktop-configs/dotfiles/ly/config.ini" /etc/ly/config.ini

sudo systemctl enable power-profiles-daemon.service
sudo usermod -aG video $USER

cd "$HOME/.local/share"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Mini*
./Mini*
