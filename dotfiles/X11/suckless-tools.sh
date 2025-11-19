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

read -p "install dwm and slock ?" $ALL

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
