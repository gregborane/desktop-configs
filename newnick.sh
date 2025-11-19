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
ask -p "Apply full Bash setup (aliases, editors, PATH)? [y/N] " ALL

# ------------------------------
# neovim wrappers
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

# ------------------------------------
# BASHRC addition
# ------------------------------------

ask "Append Bashrc configurations (tmux)?" INSTALL_BASHRC
  if [[ "$INSTALL_BASHRC" =~ ^(y|Y|[Yy]es)$ ]]; then
    if [ -f "/usr/bin/tmux"]; then
      cat <<'EOF' >> "$HOME/.bashrc"

tmux

      EOF
    fi
  fi

# ------------------------------
# Bash profile addition
# ------------------------------
ask "Set up PATH in .bash_profile?" INSTALL_PATH
if [[ "$INSTALL_PATH" =~ ^(y|Y|[Yy]es)$ ]]; then

  mkdir -p $HOME./local/bin

  if [ -f "$HOME/.bash_profile" ]; then
    cat >> "$HOME/.bash_profile" <<'EOF'

if [ -d "$HOME/.local/bin" ]; then
    PATH=$PATH:$HOME/.local/bin
fi

export PATH

    EOF
  fi

  if [ -f "$HOME/.profile"]; then
    cat >> "$HOME/.bash_profile" <<'EOF'

if [ -d "$HOME/.local/bin" ]; then
    PATH=$PATH:$HOME/.local/bin
fi

export PATH

    EOF
  fi
fi

# ------------------------------
# Bash profile addition
# ------------------------------
ask "Append Bashrc aliases?" INSTALL_BASHRC
if [[ "$INSTALL_BASHRC" =~ ^(y|Y|[Yy]es)$ ]]; then
  if [ -f $HOME/.bash_profile]; then  
    cat <<'EOF' >> "$HOME/.bash_profile"

if [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

    EOF
  fi

  if [ -f $HOME/.profile]; then
    cat <<'EOF' >> "$HOME/.bash_profile"

if [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

    EOF

  fi
fi

# ------------------------------
# Gaussian
# ------------------------------
ask "Set up Gaussian Dirs?" Gaussian
if [[ "$Gaussian" =~ ^(y|Y|[Yy]es)$ ]]; then
    cat >> "$HOME/.gaussianrc" <<'EOF'

#!/bin/bash

mkdir -p "$HOME/.local/share/applications/"
export g16root="$HOME/.local/share/gaussian"
export GAUSS_SCRDIR="$HOME/.local/share/gaussian/scratch"
. "$g16root/g16/bsd/g16.profile"
export GAUSS_CDEF=0
export GAUSS_LFLAGS='-opt'

    EOF
fi
