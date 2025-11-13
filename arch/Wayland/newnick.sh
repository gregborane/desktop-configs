#!/bin/bash

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
read -p "Apply full Bash setup (aliases, editors, PATH)? [y/N] " ALL

# ------------------------------
# Aliases
# ------------------------------
ask "Set up Bash aliases?" INSTALL_ALIASES
if [[ "$INSTALL_ALIASES" =~ ^(y|Y|[Yy]es)$ ]]; then
    cat >> "$HOME/.bash_aliases" <<'EOF'
#!/bin/bash

# sudo
alias sudo="sudo -E"
EOF
fi

# ------------------------------
# Editor wrappers
# ------------------------------
ask "Set default editor wrappers?" INSTALL_EDITORS
if [[ "$INSTALL_EDITORS" =~ ^(y|Y|[Yy]es)$ ]]; then
    sudo tee /usr/bin/vim >/dev/null <<'EOF'
#!/bin/bash
nvim "$@"
EOF
sudo chmod +x /usr/bin/vim

sudo tee /usr/bin/nano >/dev/null <<'EOF'
#!/bin/bash
nvim "$@"
EOF
sudo chmod +x /usr/bin/nano
fi

# ------------------------------
# Bashrc additions
# ------------------------------
ask "Append Bashrc configurations (aliases, tmux)?" INSTALL_BASHRC
if [[ "$INSTALL_BASHRC" =~ ^(y|Y|[Yy]es)$ ]]; then
    cat <<'EOF' >> "$HOME/.bashrc"

f [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.gaussianrc" ]; then
    source "$HOME/.gaussianrc"
fi

tmux

EOF
fi

# ------------------------------
# Bash profile PATH setup
# ------------------------------
ask "Set up PATH in .bash_profile?" INSTALL_PATH
if [[ "$INSTALL_PATH" =~ ^(y|Y|[Yy]es)$ ]]; then
    cat >> "$HOME/.bash_profile" <<'EOF'

if [ -d "$HOME/.local/bin" ]; then
    PATH=$PATH:$HOME/.local/bin
fi

export PATH
EOF
fi

# ------------------------------
# Gaussian
# ------------------------------
ask "Set up Gaussian Dirs?" Gaussian
if [[ "$Gaussian" =~ ^(y|Y|[Yy]es)$ ]]; then
    cat >> "$HOME/.gaussianrc" <<'EOF'
#!/bin/bash

export g16root=/home/alex/gaussian
export GAUSS_SCRDIR=/home/alex/gaussian/scratch
export PATH=/home/alex/gaussian/g16:$PATH
export PATH=/home/alex/gaussian/gv/:$PATH
source $g16root/g16/bsd/g16.profile
export GAUSS_CDEF=0
export GAUSS_LFLAGS='-opt'

EOF
fi
