#!/bin/bash

sudo tee /etc/pacman.conf <<'EOF'

[lizardbyte]
SigLevel = Optional
Server = https://github.com/LizardByte/pacman-repo/releases/latest/download
EOF
