#!/bin/bash
cd "$HOME/.local/share/ly"
zig build
sudo zig build installexe -Dinit_system=systemd
sudo systemctl disable getty@tty.service
sudo cp "$HOME/.config/desktop-configs/dotfiles/ly/config.ini" /etc/ly/config.ini

