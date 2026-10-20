#!/usr/bin/env bash
set -euo pipefail

install_dir="$HOME/.local/share/pinokio"

mkdir -p "$install_dir" \
    "$HOME/.local/bin" \
    "$HOME/.local/share/applications"

# Download AppImage
wget -O "$install_dir/pinokio.appimage" \
    "https://github.com/pinokiocomputer/pinokio/releases/download/v8.2.0/Pinokio-8.2.0.AppImage"

# Create launcher
cat >"$HOME/.local/bin/pinokio" <<EOF
#!/usr/bin/env bash
exec appimage-run "$install_dir/pinokio.appimage" "\$@"
EOF

chmod +x "$HOME/.local/bin/pinokio"

# Create desktop entry
cat >"$HOME/.local/share/applications/pinokio.desktop" <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Pinokio
Comment=Install and run programs
Exec=$HOME/.local/bin/pinokio %F
Terminal=false
Categories=Viewer;Graphics;
EOF
