#!/bin/bash

LOCAL="$HOME/.local"
CONFIG="$HOME/.config"

rm -rf "$LOCAL/bash"
cp -rf "$CONFIG/desktop-configs/local/bash" "$LOCAL"

rm -rf "$LOCAL/bin"
cp -rf "$CONFIG/desktop-configs/local/bin" "$LOCAL/bin"

rm "$HOME/.bash_profile"
cp "$CONFIG/desktop-configs/local/bash_profile" "$HOME/.bash_profile"



