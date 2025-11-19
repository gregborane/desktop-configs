#!/bin/bash

set -e

yay -S vesktop
yay -S hyprshot
yay -S hyprlock
yay -S hypridle
yay -S wiremix
yay -S proton-ge-custom-bin
yay -S ttf-ms-fonts
yay -S plymouth-theme-dna-git
yay -S kvantum-qt6-git

cd $HOME/.local/share/
wget https://github.com/PancakeTAS/lsfg-vk/releases/download/v1.0.0/lsfg-vk-1.0.0.x86_64.tar.zst
sudo pacman -U lsfg-vk*
rm lsfg-vk*

# install miniconda
cd $HOME/.local/share
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Mini*
./Mini*
rm Mini*

mkdir -p $HOME/.fonts && cd $HOME/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
unzip CascadiaCode && fc-cache -f
rm *.zip

sudo plymouth-set-default-theme -R dna
