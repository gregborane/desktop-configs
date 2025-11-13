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
read -p "Apply full Bash setup (zoxide, aliases, editors, PATH)? [y/N] " ALL

# ------------------------------
# zoxide
# ------------------------------
ask "Install zoxide?" INSTALL_ZOXIDE
if [[ "$INSTALL_ZOXIDE" =~ ^(y|Y|[Yy]es)$ ]]; then
    zoxide init bash >> "$HOME/.bash_zoxide"
    cat <<'EOF' >> "$HOME/.bashrc"
if [ -f "$HOME/.bash_zoxide" ]; then
    . "$HOME/.bash_zoxide"
fi
EOF
fi

# ------------------------------
# Aliases
# ------------------------------
ask "Set up Bash aliases?" INSTALL_ALIASES
if [[ "$INSTALL_ALIASES" =~ ^(y|Y|[Yy]es)$ ]]; then
    cat >> "$HOME/.bash_aliases" <<'EOF'
#!/bin/bash

# ls
alias ls="ls --color=auto"
alias ll="ls -lFA"
alias la='ls -a'
alias l='ls -CF'
alias lsd='ls -d */'
alias lh='ls -lh'
alias lsr='ls -R'

# tree
alias lt="tree -C ."

# grep
alias grep="grep --color=auto"

# cd
alias cd="z"

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

    sudo tee /usr/bin/gedit >/dev/null <<'EOF'
#!/bin/bash
gnome-text-editor "$@"
EOF
    sudo chmod +x /usr/bin/gedit

    sudo tee /usr/bin/nano >/dev/null <<'EOF'
#!/bin/bash
nvim "$@"
EOF
    sudo chmod +x /usr/bin/nano
fi

# ------------------------------
# Bashrc additions
# ------------------------------
ask "Append Bashrc configurations (editor, TERM, tmux, oh-my-posh source)?" INSTALL_BASHRC
if [[ "$INSTALL_BASHRC" =~ ^(y|Y|[Yy]es)$ ]]; then
    cat <<'EOF' >> "$HOME/.bashrc"
if [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

export TERM='xterm-256color'
export EDITOR='nvim'
export VISUAL='nvim'

tmux

eval $(ssh-agent -s) >> /dev/null

eval $(oh-my-posh init bash --config /home/greg/.config/omp/theme.json)
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

if [ -d "$HOME/Scripts" ]; then
    PATH=$PATH:$HOME/Scripts
fi

source $HOME/.gaussianrc
xset +fp /usr/share/fonts/misc/spleen
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
