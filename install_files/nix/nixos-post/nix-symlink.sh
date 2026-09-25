#!/bin/bash

SRC="$HOME/nixos-dotfiles/desktop-configs/install_files/nix/nixos-post"
DEST="$HOME/nixos-dotfiles"

ln -s "$SRC/configuration.nix" "$DEST/configuration.nix"
ln -s "$SRC/flake.nix" "$DEST/flake.nix"
ln -s "$SRC/home.nix" "$DEST/home.nix"
ln -s "$SRC/hardware-configuration.nix" "$DEST/hardware-configuration.nix"
ln -s "$SRC/flake.lock" "$DEST/flake.lock"

if [ -f "$SRC/eduroam.nix" ]; then
    ln -s "$SRC/eduroam.nix" "$DEST/eduroam.nix"
fi
