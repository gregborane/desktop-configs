#!/bin/bash

set -e

sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service
sudo systemctl set-default graphical.target
sudo apt -t unstable install nvidia-vaapi-driver libva2 libva-wayland2 libva-x11-2 ffmpeg libavcodec61 mesa-va-drivers vainfo
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
