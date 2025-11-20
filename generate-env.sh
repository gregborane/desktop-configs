#!/usr/bin/env bash
set -euo pipefail

### -------------------------
### Helper: ask yes/no
### -------------------------
ask() {
    local prompt="$1"
    local default="${2:-N}"
    local reply

    printf "%s [%s] " "$prompt" "$default"
    read -r reply

    reply="${reply:-$default}"

    [[ "$reply" =~ ^([Yy]|[Yy]es)$ ]] && return 0 || return 1
}

### -------------------------
### Ensure ~/.local/bin exists
### -------------------------
ensure_local_bin() {
    mkdir -p "$HOME/.local/bin"
}

### -------------------------
### Add block to a file once
### -------------------------
append_once() {
    local file="$1"
    local marker="$2"
    local block="$3"

    mkdir -p "$(dirname "$file")"
    touch "$file"

    if ! grep -q "$marker" "$file"; then
        printf "\n# %s\n%s\n" "$marker" "$block" >> "$file"
        echo "[✓] Added block: $marker → $file"
    else
        echo "[=] Already present: $marker → $file"
    fi
}

### -------------------------
### Install editor wrappers
### -------------------------
install_editors() {
    ensure_local_bin

    cat > "$HOME/.local/bin/vim" <<'EOF'
#!/usr/bin/env bash
nvim "$@"
EOF

    cat > "$HOME/.local/bin/nano" <<'EOF'
#!/usr/bin/env bash
nvim "$@"
EOF

    chmod +x "$HOME/.local/bin/vim" "$HOME/.local/bin/nano"

    echo "[✓] Installed Neovim wrappers in ~/.local/bin"
}

### -------------------------
### Add tmux autostart
### -------------------------
install_tmux_autostart() {
    local block='[ -z "$TMUX" ] && command -v tmux >/dev/null && tmux'
    append_once "$HOME/.bashrc" "TMUX_AUTOSTART" "$block"
}

### -------------------------
### Ensure PATH includes ~/.local/bin
### -------------------------
install_path_setup() {
    local block='
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    PATH="$PATH:$HOME/.local/bin"
fi
export PATH
'
    append_once "$HOME/.profile" "LOCAL_BIN_PATH" "$block"
}

### -------------------------
### Gaussian config
### -------------------------
install_gaussian() {

    mkdir -p "$HOME/.local/share/gaussian"
    mkdir -p "$HOME/.local/share/gaussian/scratch"

    local block='
export g16root="$HOME/.local/share/gaussian"
export GAUSS_SCRDIR="$HOME/.local/share/gaussian/scratch"
. "$g16root/g16/bsd/g16.profile"
export GAUSS_CDEF=0
export GAUSS_LFLAGS="-opt"
'
    append_once "$HOME/.gaussianrc" "GAUSSIAN_CONFIG" "$block"
}

### -------------------------
### MAIN INSTALLER
### -------------------------
main() {
    echo "-------------------------------------------"
    echo "   Bash Environment Setup Utility"
    echo "-------------------------------------------"

    if ask "Install Neovim editor wrappers (vim → nvim, nano → nvim)?" "N"; then
        install_editors
    fi

    if ask "Enable tmux autostart on shell login?" "N"; then
        install_tmux_autostart
    fi

    if ask "Ensure ~/.local/bin is added to PATH?" "Y"; then
        install_path_setup
    fi

    if ask "Enable loading ~/.bash_aliases?" "Y"; then
        install_alias_loader
    fi

    if ask "Install Gaussian environment settings?" "N"; then
        install_gaussian
    fi

    echo
    echo "[✓] Setup complete! Restart your shell."
}

main "$@"

