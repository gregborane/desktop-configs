#!/usr/bin/env bash
set -euo pipefail

install_dir="$HOME/.local/share/pdfcraft"

mkdir -p "$install_dir" \
    "$HOME/.local/bin" \
    "$HOME/.local/share/applications"

# Download AppImage
wget -O "$install_dir/pdfcraft.appimage" \
    "https://github.com/storytold/pdfcraft/releases/download/v0.8.0/pdfcraft-0.8.0-linux-x86_64.AppImage"

# Create launcher
cat >"$HOME/.local/bin/pdfcraft" <<EOF
#!/usr/bin/env bash
exec appimage-run "$install_dir/pdfcraft.appimage" "\$@"
EOF

chmod +x "$HOME/.local/bin/pdfcraft"

# Create desktop entry
cat >"$HOME/.local/share/applications/pdfcraft.desktop" <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=PDFCraft
Comment=Edit and Read PDF
Exec=$HOME/.local/bin/pdfcraft %F
Terminal=false
Categories=Office;Viewer;Graphics;
MimeType=application/pdf;
EOF
