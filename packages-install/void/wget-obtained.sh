# discord
wget https://vencord.dev/download/vesktop/amd64/appimage

# localsend
wget https://github.com/localsend/localsend/releases/download/v1.17.0/LocalSend-1.17.0-linux-x86-64.AppImage

# proton-ge
wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-28/GE-Proton10-28.tar.gz

# manual build or associated refer to pages in the cage for manual build.

# zentile
wget https://github.com/blrsn/zentile/releases/download/v0.1.1/zentile_linux_amd64

# ly
git clone https://codeberg.org/fairyglade/ly.git "$HOME/.local/share/ly"
cd "$HOME/.local/share/ly"
zig build installexe -Dinit_system=runit
rm /var/service/lightdm
ln -s /etc/sv/ly /var/service/
rm /var/service/agetty-tty2

# Miniconda
cd $HOME/.local/share
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Mini*
./Mini*
rm Mini*

# font
mkdir -p $HOME/.fonts && cd $HOME/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
unzip CascadiaCode && fc-cache
rm *.zip
