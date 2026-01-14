#!/bin/bash

LOCAL="$HOME/.local"
CONFIG="$HOME/.config"

rm -rf "$LOCAL/bash"
cp -rf "$CONFIG/desktop-configs/local/bash" "$LOCAL"

mkdir -p "$LOCAL/bin"
cp -rf "$CONFIG/desktop-configs/local/bin/*" "$LOCAL/bin"

cp "$CONFIG/desktop-configs/local/bash_profile" "$HOME/.bash_profile"



