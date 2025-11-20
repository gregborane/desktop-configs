#!/bin/bash

set -e

cd $HOME/.local/share
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S vesktop
yay -S hyprshot
yay -S hyprlock
yay -S hypridle
yay -S hyprpaper
yay -S hyprsunset
yay -S wiremix
yay -S proton-ge-custom-bin
yay -S ttf-ms-fonts
yay -S plymouth-theme-dna-git
yay -S kvantum-qt6-git
yay -S localsend
yay -S ufw-docker
yay -S vscodium-bin
yay -S xdg-terminal-exec
