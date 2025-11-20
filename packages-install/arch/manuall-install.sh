#!/bin/bash

cd $HOME/.local/share/
wget https://github.com/PancakeTAS/lsfg-vk/releases/download/v1.0.0/lsfg-vk-1.0.0.x86_64.tar.zst
sudo pacman -U lsfg-vk*
rm lsfg-vk*

cd $HOME/.local/share
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Mini*
./Mini*
rm Mini*

mkdir -p $HOME/.fonts && cd $HOME/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
unzip CascadiaCode && fc-cache
rm *.zip

sudo plymouth-set-default-theme -R dna
# add plymouth in hook /etc/mkinitcpio.conf and sudo mkinitcpio -P

sudo systemctl stop ly.service
sudo systemctl disable ly.service
git clone https://codeberg.org/fairyglade/ly.git "$HOME/.local/share/ly"
cd "$HOME/.local/share/ly"
zig build
zig build installexe -Dinit_system=systemd
sudo systemctl disable getty@tty.service
sudo cp "$HOME/.config/desktop-configs/dotfiles/ly/config.ini" /etc/ly/config.ini

sudo ln -s /usr/share/applications/com.mitchellh.ghostty.desktop /usr/share/xdg-terminals
echo com.mitchellh.ghostty.desktop > ~/.config/xdg-terminals.list
