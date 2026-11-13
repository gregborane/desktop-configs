#!/usr/bin/env bash
set -euo pipefail

install_dir="$HOME/.local/share/deckcraft"

mkdir -p "$install_dir" \
    "$HOME/.local/bin" \
    "$HOME/.local/share/applications"

# Download AppImage
wget -O "$install_dir/deckcraft.appimage" \
    "https://github.com/storytold/deckcraft/releases/download/v0.18.0/deckcraft-0.18.0-linux-x86_64.AppImage"

# Create launcher
cat >"$HOME/.local/bin/deckcraft" <<EOF
#!/usr/bin/env bash
exec appimage-run "$install_dir/deckcraft.appimage" "\$@"
EOF

chmod +x "$HOME/.local/bin/deckcraft"

# Create desktop entry
cat >"$HOME/.local/share/applications/deckcraft.desktop" <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=DeckCraft
Comment=Edit and Read Powerpoint
Exec=$HOME/.local/bin/deckcraft %F
Terminal=false
Categories=Office;Viewer;Graphics;
MimeType=application/pdf;
EOF
