#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob dotglob

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

configs=(
    btop
    hypr
    noctalia
    fastfetch
    ghostty
    fontconfig
    gtk-3.0
    gtk-4.0
    qt5ct
    qt6ct
    nvim
    starship.toml
    mimeapps.list
)

local_dirs=(
    bash
    bin
)

BACKUP_DIR="$HOME/.local/state/dotfiles-backups/$(date +%Y%m%d-%H%M%S%N)"

# Back up existing files and directories
backup() {
    local dst="$1"

    if [[ -e "$dst" || -L "$dst" ]]; then
        local target="$BACKUP_DIR/${dst#"$HOME"/}"

        mkdir -p "$(dirname "$target")"
        mv "$dst" "$target"

        echo "Backup: $dst -> $target"
    fi
}

# Create a symlink if not already linked
link_item() {
    local src="$1"
    local dst="$2"

    [[ -e "$src" ]] || return

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        echo "Already linked: $dst"
        return
    fi

    mkdir -p "$(dirname "$dst")"

    backup "$dst"
    ln -s "$src" "$dst"

    echo "Linked: $dst -> $src"
}

# 1. Symlink application configurations
for name in "${configs[@]}"; do
    link_item "$REPO/config/$name" "$HOME/.config/$name"
done

# 2. Symlink local directories
for name in "${local_dirs[@]}"; do
    link_item "$REPO/local/$name" "$HOME/.local/$name"
done

# 3. Symlink icon packs and themes
for name in fonts icons themes; do
    src="$REPO/$name"
    dst="$HOME/.local/share/$name"

    [[ -d "$src" ]] || continue

    for item in "$src"/*; do
        link_item "$item" "$dst/$(basename "$item")"
    done
done

echo "Installation complete."
