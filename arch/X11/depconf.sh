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
cp -r "$HOME/.config/dwmdesktop/Scripts" "$HOME/"

# ------------------------------
# Config folders
# ------------------------------
mkdir -p "$HOME/.fonts" "$HOME/.icons" "$HOME/.themes"

# ------------------------------
# Fonts
# ------------------------------
ask "Install FiraMono Nerd font?" FONT
if [[ "$FONT" =~ ^(y|Y|[Yy]es)$ ]]; then
    cd "$HOME/.fonts" || exit
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip
    unzip -oq FiraMono.zip
    rm -f FiraMono.zip
fi

# ------------------------------
# Cursors
# ------------------------------
ask "Install Bibata Modern Ice cursors?" CURSOR
if [[ "$CURSOR" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp -r "$HOME/.config/dwmdesktop/Bibata-Modern-Ice" "$HOME/.icons/"
fi

# ------------------------------
# Icons
# ------------------------------
ask "Install Zafiro icons?" ICON
if [[ "$ICON" =~ ^(y|Y|[Yy]es)$ ]]; then
    cd "$HOME/.icons" || exit
    git clone -q https://github.com/zayronxio/Zafiro-icons.git
    mv Zafiro-icons/Dark .
    rm -rf Zafiro-icons
fi

# ------------------------------
# GTK Theme
# ------------------------------
ask "Install Nordic Theme?" THEME
if [[ "$THEME" =~ ^(y|Y|[Yy]es)$ ]]; then
    cd "$HOME/.themes" || exit
    git clone -q https://github.com/EliverLara/Nordic.git
fi

# ------------------------------
# Wallpapers
# ------------------------------
ask "Move wallpapers to $HOME/.config ?" WALLPAPERS
if [[ "$WALLPAPERS" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp "$HOME/.config/dwmdesktop/wallpaper.png" "$HOME/.config/"
    cp "$HOME/.config/dwmdesktop/lock.png" "$HOME/.config/"
fi

# ------------------------------
# TMUX
# ------------------------------
ask "Use TMUX configuration?" TMUX
if [[ "$TMUX" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp "$HOME/.config/dwmdesktop/.tmux.conf" "$HOME"
fi

# ------------------------------
# Rofi
# ------------------------------
ask "Use Rofi configuration?" ROFI
if [[ "$ROFI" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp -r "$HOME/.config/dwmdesktop/rofi" "$HOME/.config/"
fi

# ------------------------------
# Neovim
# ------------------------------
ask "Use Neovim configuration?" NEOVIM
if [[ "$NEOVIM" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp -r "$HOME/.config/dwmdesktop/nvim" "$HOME/.config/"
fi

# ------------------------------
# Terminal
# ------------------------------
ask "Use Alacritty configuration?" CRITTY
if [[ "$CRITTY" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp -r "$HOME/.config/dwmdesktop/alacritty" "$HOME/.config/"
    alacritty migrate
fi

# ------------------------------
# Oh-my-posh
# ------------------------------
ask "Use AMRO theme with Oh-my-posh?" AMRO
if [[ "$AMRO" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp -r "$HOME/.config/dwmdesktop/omp" "$HOME/.config/"
fi

# ------------------------------
# Fontconfig
# ------------------------------
ask "Use FontConfig Configuration?" FONTCONF
if [[ "$FONTCONF" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp -r "$HOME/.config/dwmdesktop/fontconfig" "$HOME/.config/"
fi

# ------------------------------
# Picom
# ------------------------------
ask "Use Picom Configuration?" PICOM
if [[ "$PICOM" =~ ^(y|Y|[Yy]es)$ ]]; then
    cp -r "$HOME/.config/dwmdesktop/picom" "$HOME/.config/"
fi

# ------------------------------
# DWM
# ------------------------------
ask "Use inside DWM config?" DWMCONF
if [[ "$DWMCONF" =~ ^(y|Y|[Yy]es)$ ]]; then
    ask "Use proposed default start up (with DWM only)?" DWMSTART
    if [[ "$DWMSTART" =~ ^(y|Y|[Yy]es)$ ]]; then
        mkdir -p "$HOME/.dwm"
        cp "$HOME/.config/dwmdesktop/autostart.sh" "$HOME/.dwm/"
	cp "$HOME/.config/dwmdesktop/lock.sh" "$HOME/.dwm/"
    fi

    cp -r "$HOME/.config/dwmdesktop/dwm" "$HOME/.config/"
    cd "$HOME/.config/dwm" || exit
    sudo make clean install

    cp /etc/X11/xinit/xinitrc "$HOME/.xinitrc"
    sed -i '$d' "$HOME/.xinitrc"
    echo "exec dwm" >> "$HOME/.xinitrc"

    cat <<'EOF' >> "$HOME/.bash_profile"
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	exec startx
fi
EOF

    sudo mkdir -p /usr/share/xsessions
    sudo tee /usr/share/xsessions/dwm.desktop >/dev/null <<EOF
[Desktop Entry]
Name=DWM
Comment=Light Weight Tiling Window Manager
Exec=/usr/local/bin/dwm
Type=Application
EOF
fi

# ------------------------------
# Apply fonts
# ------------------------------
fc-cache -f

# ------------------------------
# Display Manager
# ------------------------------
ask "Enable SDDM login manager?" SDDM
if [[ "$SDDM" =~ ^(y|Y|[Yy]es)$ ]]; then
    sudo systemctl enable sddm
fi

# ------------------------------
# Desktop Files
# ------------------------------
ask "Create desktop files for all utilies?" UTILITIES
if [[ "$UTILIES" =~ ^(y|Y|[Yy]es)$ ]]; then
	if [[ ! -d "$HOME/.local/share/applications" ]]: then
		mkdir $HOME/.local/share/applications
	fi

	mv "$HOME/.config/dwmdesktop/desktop_files/*" "$HOME/.local/share/applications"
fi

# ------------------------------
# Slock
# ------------------------------
ask "Install Slock?" SLOCK
if [[ "$SLOCK" =~ ^(y|Y|[Yy]es)$ ]]; then
	cd $HOME/.fonts/
	git clone https://github.com/fcambus/spleen.git
	sudo mv $HOME/.fonts/spleen /usr/share/fonts/misc
	sudo mkfontscale
	sudo mkfontdir
	sudo fc-cache -fv
	xset +fp /usr/share/fonts/misc/spleen
	echo "xset +fp /usr/share/fonts/misc/spleen" >> ~/.xinitrc
	cp "$HOME/.config/dwmdesktop/slock" "$HOME/.config"

	cd "$HOME/.config/slock" || exit
	sudo make clean install
fi
