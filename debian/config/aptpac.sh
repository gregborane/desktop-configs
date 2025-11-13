#!/bin/bash
set -e

# Update and upgrade
sudo apt update
sudo apt full-upgrade 

# Core and utilities
sudo apt -t unstable install  \
eza aspell atril \
build-essential bash-completion \
chromium ghostty biber \
cmake composer php-cli php-curl php-zip php-xml php-gd php-mbstring \
curl dkms \
ffmpeg fontconfig fuse3 fzf \
gimp gimp-data-extra gimp-help-en ghostscript git \
hdf5-tools hspell htop imagemagick \
default-jdk \
less libreoffice libopenal-dev neovim ninja-build fonts-noto-color-emoji \
nuspell nwg-look \
obs-studio openssh-server openssh-client \
pavucontrol python3-neovim \
wireplumber \
pipewire-pulse pipewire-alsa pipewire-jack pavucontrol \
qtbase5-dev qt6-wayland* \
r-base ripgrep ruby-full \
sqlite3 sshfs steam-installer starship \
nautilus texlive timeshift tree-sitter-cli thunderbird \
upower unzip \
vlc wget wine64 wine32 \
zathura zip zoxide

# Databases, diagramming, misc
sudo apt -t unstable install  \
mariadb-server mariadb-client \
nodejs npm

# Clean up
sudo apt autoremove -y
sudo apt clean

# install ueberzugpp
echo 'deb http://download.opensuse.org/repositories/home:/justkidding/Debian_Unstable/ /' | sudo tee /etc/apt/sources.list.d/home:justkidding.list
curl -fsSL https://download.opensuse.org/repositories/home:justkidding/Debian_Unstable/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_justkidding.gpg > /dev/null
sudo apt update
sudo apt install ueberzugpp

# installing uwsm app
cd $HOME/App
git clone https://github.com/Vladimir-csp/uwsm
cd uwsm
./build-deb -i

# installing hyprshot
cd $HOME/App && mkdir -p ~/.local/bin
sudo apt install -t unstable jq grim slurp wl-clipboard libnotify-bin
git clone https://github.com/Gustash/hyprshot.git hyprshot
ln -s $(pwd)/hyprshot/hyprshot $HOME/.local/bin/hyprshot
chmod +x hyprshot/hyprshot

# install a mono nerd font
bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"

# install vesktop
cd $HOME/App
wget https://vencord.dev/download/vesktop/amd64/deb
sudo dpkg -i deb
rm deb

# install wiremix
cd $HOME/App
sudo apt install libpipewire-0.3-dev pkg-config clang rustup
rustup default stable
git clone https://github.com/tsowell/wiremix
cd wiremix 
cargo install wiremix
ln -s $HOME/.cargo/bin/wiremix $HOME/.local/bin/wiremix

# install miniconda
cd $HOME/App
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Mini*
./Mini*

