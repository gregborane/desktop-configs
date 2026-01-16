#!/bin/bash

set -e

CONFIG="$HOME/.config"

rm -rf "$CONFIG/fastfetch"
ln -s "$CONFIG/desktop-configs/config/fastfetch" "$CONFIG/fastfetch"

rm -rf "$CONFIG/fontconfig"
ln -s "$CONFIG/desktop-configs/config/fontconfig" "$CONFIG/fontconfig"

rm -rf "$CONFIG/ghostty"
ln -s "$CONFIG/desktop-configs/config/ghostty" "$CONFIG/ghostty"

rm -rf "$CONFIG/gtk-3.0"
ln -s "$CONFIG/desktop-configs/config/gtk-3.0" "$CONFIG/gtk-3.0"

rm -rf "$CONFIG/gtk-4.0"
ln -s "$CONFIG/desktop-configs/config/gtk-4.0" "$CONFIG/gtk-4.0"

rm -rf "$CONFIG/hypr"
ln -s "$CONFIG/desktop-configs/config/hypr" "$CONFIG/hypr"

rm -rf "$CONFIG/mako"
ln -s "$CONFIG/desktop-configs/config/mako" "$CONFIG/mako"

rm -rf "$CONFIG/nvim"
ln -s "$CONFIG/desktop-configs/config/nvim" "$CONFIG/nvim"

rm -rf "$CONFIG/nwg-look"
ln -s "$CONFIG/desktop-configs/config/nwg-look" "$CONFIG/nwg-look"

rm -rf "$CONFIG/swayosd"
ln -s "$CONFIG/desktop-configs/config/swayosd" "$CONFIG/swayosd"

rm -rf "$CONFIG/uwsm"
ln -s "$CONFIG/desktop-configs/config/uwsm" "$CONFIG/uwsm"

rm -rf "$CONFIG/waybar"
ln -s "$CONFIG/desktop-configs/config/waybar" "$CONFIG/waybar"

rm -rf "$CONFIG/wofi"
ln -s "$CONFIG/desktop-configs/config/wofi" "$CONFIG/wofi"

rm -rf "$CONFIG/hypr"
ln -s "$CONFIG/desktop-configs/config/hypr" "$CONFIG/hypr"

rm -rf "$CONFIG/chromium-flags.conf"
ln -s "$CONFIG/desktop-configs/config/chromium-flags.conf" "$CONFIG/chromium-flags.conf"

rm -rf "$CONFIG/starship.toml"
ln -s "$CONFIG/desktop-configs/config/starship.toml" "$CONFIG/starship.toml"

rm -rf "$CONFIG/tmux.conf"
ln -s "$CONFIG/desktop-configs/config/tmux.conf" "$CONFIG/tmux.conf"

rm -rf "$HOME/.XCompose"
ln -s "$CONFIG/desktop-configs/config/XCompose" "$HOME/.XCompose"



