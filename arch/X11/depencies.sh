#!/bin/bash

# Copy dwmdesktop config if missing
if [ ! -d "$HOME/.config/dwmdesktop" ]; then
	cp -r $(pwd) "$HOME/.config"
fi

# Install some packages
$HOME/.config/dwmdesktop/X11/pacpack.sh

# Config
$HOME/.config/dwmdesktop/X11/depconf.sh

# Aliases, Wrapper
$HOME/.config/dwmdesktop/X11/newnick.sh

# Set up AUR helper
cd $HOME
git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si --noconfirm
