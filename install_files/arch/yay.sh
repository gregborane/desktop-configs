#!/bin/bash

cd $HOME/.local/share
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S vesktop

yay -S mkinitcpio-tailscale
yay -S mkinitcpio-extras 

yay -S hyprshot
yay -S hyprlock
yay -S hypridle

yay -S wiremix

yay -S proton-ge-custom-bin

yay -S ttf-ms-fonts

yay -S plymouth-theme-dna-git
yay -S plymouth-theme-lone-git
sudo plymouth-set-default-theme -R lone

yay -S localsend

yay -S vscodium

yay -S xdg-terminal-exec
sudo ln -s /usr/share/applications/com.mitchellh.ghostty.desktop /usr/share/xdg-terminals
echo com.mitchellh.ghostty.desktop > ~/.config/xdg-terminals.list

yay -S qbittorrent
