#!/bin/bash

# ==============================
# Setup Script for dwmdesktop
# ==============================

ask() {
    local prompt="$1"
    local varname="$2"
    if [[ "$ALL" =~ ^(y|Y|[Yy]es)$ ]]; then
        printf -v "$varname" "yes"
    else
        read -p "$prompt [y/N] " "$varname"
    fi
}

# ------------------------------
# Global ALL
# ------------------------------
read -p "Install all components? [y/N] " ALL

# ------------------------------
# Base folders
# ------------------------------
mkdir -p "$HOME/Downloads" "$HOME/Documents" "$HOME/Pictures" "$HOME/Music" "$HOME/Templates" "$HOME/App"

# ------------------------------
# Config folders
# ------------------------------
mkdir -p "$HOME/.fonts" "$HOME/.icons" "$HOME/.themes"

# ------------------------------
# TMUX
# ------------------------------
ask "Use TMUX configuration?" TMUX
if [[ "$TMUX" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp "$HOME/.config/dwmdesktop/Wayland/matte-black/.tmux.conf" "$HOME"
fi

# ------------------------------
# Neovim
# ------------------------------
ask "Use Neovim configuration?" NEOVIM
if [[ "$NEOVIM" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp -r "$HOME/.config/dwmdesktop/Wayland/nvim" "$HOME/.config/"
fi

# ------------------------------
# Matte Black
# ------------------------------
ask "Use Matte Black configuration" MATTE
if [["$MATEBLACK" =~ ^(y|Y|[Yyes])$ ]]; then
  cp -r "$HOME/.config/dwmdesktop/Wayland/matte-black/" "$HOME/.config/omarchy/themes/"
fi

# ------------------------------
# Starship
# ------------------------------
ask "Use Starship configuration" STARSHIP
if [["$STARSHIP" =~ ^(y|Y|[Yyes])$ ]]; then
  cp "$HOME/.config/dwmdesktop/Wayland/starship.toml" "$HOME/.config/starship.toml"
fi


# ------------------------------
# PYTHON
# ------------------------------
ask "Move PYTHON installation files?" PYTHON
if [["$PYTHON" =~ ^(y|Y|[Yyes])$ ]]; then
  cp -r "$HOME/.config/dwmdesktop/Wayland/python" "$HOME/Work/python"
fi

# ------------------------------
# Scripts
# ------------------------------
ask "Install Custom Scripts ?" SCRIPTS
if [["$SCRIPTS" =~ ^(y|Y|[Yyes])$ ]]; then
  cp "$HOME/.config/dwmdesktop/Wayland/Scripts/*" "$HOME/.local/bin"
fi



