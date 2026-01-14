#!/bin/bash

CONFIG="$HOME/.config"
FONTS="$HOME/.fonts"

mkdir -p "$FONTS"
cp -rf "$CONFIG/desktop-configs/fonts/*" "$FONTS"
fc-cache
