#!/bin/bash

set -e

# NVIDIA Drivers
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -t unstable libglvnd-core-dev libglvnd0 libglvnd-dev libc-dev xwayland libxcb1 libnvidia-egl-wayland1
sudo tee /etc/modprobe.d/blacklist.conf >/dev/null <<"EOF"
blacklist nouveau
options nouveau modeset=0
EOF

sudo tee /etc/modprobe.d/nvidia.conf >/dev/null <<"EOF"
options nvidia NVreg_PreserveVideoMemoryAllocations=1 
options nvidia-drm modeset=1 fbdev=1
EOF

sudo update-initramfs -u
mkdir -p $HOME/Drivers && cd $HOME/Drivers
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/580.105.08/NVIDIA-Linux-x86_64-580.105.08.run
chmod +X NVDIA*

#reboot 
sudo reboot

#post reboot commands

# sudo $HOME/Drivers/NVI*
# sudo reboot

