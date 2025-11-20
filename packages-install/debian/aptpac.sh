#!/bin/bash
set -e

sudo apt update
sudo apt full-upgrade 

sudo apt -t unstable install \
aspell atril \
bash-completion biber build-essential \
chromium cmake composer curl \
default-jdk dkms \
eza \
ffmpeg fontconfig fonts-noto-color-emoji fuse3 fzf \
gamemode gamescope gimp gimp-data-extra gimp-help-en ghostscript ghostty git \
hdf5-tools hspell htop \
imagemagick \
less libdbus-1-dev libinih-dev libopenal-dev libreoffice libsystemd-de lutris luarocks \
mariadb-client mariadb-server \
nautilus neovim ninja-build nodejs npm nuspell nwg-look \
obs-studio openssh-client openssh-server \
pavucontrol php-cli php-curl php-gd php-mbstring php-xml php-zip pipewire-alsa pipewire-jack pipewire-pulse python3-neovim \
qt6-wayland* qtbase5-dev \
r-base ripgrep ruby-full \
sqlite3 sshfs starship steam-installer \
texlive thunderbird timeshift tree-sitter-cli \
unzip upower \
vlc \
wget wine32 wine64 wireplumber \
zathura zip zoxide

# clean up
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
./build-deb.sh -i

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
rm Mini*

# install linux-zabblyn
sudo mkdir -p /etc/apt/keyrings/
sudo curl -fsSL https://pkgs.zabbly.com/key.asc -o /etc/apt/keyrings/zabbly.asc
sudo sh -c 'cat <<EOF > /etc/apt/sources.list.d/zabbly-kernel-stable.sources
Enabled: yes
Types: deb
URIs: https://pkgs.zabbly.com/kernel/stable
Suites: trixie
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/zabbly.asc

EOF'
sudo apt update 
sudo apt install linux-zabbly

# qt customisation
sudo add-apt-repository ppa:papirus/papirus
sudo apt update
sudo apt install qt-style-kvantum qt-style-kvantum-themes

# localsend 
sudo apt install -t unstable gir1.2-ayatanaappindicator3-0.1  libayatana-appindicator3-1  libayatana-ido3-0.4-0  libayatana-indicator3-7
wget https://github.com/localsend/localsend/releases/download/v1.17.0/LocalSend-1.17.0-linux-x86-64.deb
sudo dpkg -i Local*
rm Local*
