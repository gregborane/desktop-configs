#!/bin/bash

CONFIG="$HOME/.config"
FONTS="$HOME/.fonts"

rm -rf "$FONTS"
cp -rf "$CONFIG/desktop-configs/fonts" "$FONTS"
fc-cache
