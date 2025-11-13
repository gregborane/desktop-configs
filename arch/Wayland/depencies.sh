#!/bin/bash

# Copy dwmdesktop config if missing
if [ ! -d "$HOME/.config/dwmdesktop" ]; then
	cp -r $(pwd) "$HOME/.config"
fi

# Install some packages
$HOME/.config/dwmdesktop/Wayland/pacpack.sh

# Config
$HOME/.config/dwmdesktop/Wayland/depconf.sh

# Aliases, Wrapper
$HOME/.config/dwmdesktop/Wayland/newnick.sh

# Set up AUR helper
cd $HOME
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm
