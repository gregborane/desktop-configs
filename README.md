# desktop-configs

Find my different packages and app I usually use for my config

Bash:

- aliases
- fonctions
- configs
- packages used in bash

Local:

- bin
- bash

Config:

- config files for rice

This is config works for Wayland compositors : Sway, Hyprland, DWL based on noctalia shell.

- Bash set up is from the [Omarchy](https://omarchy.org/) project.
- Grub theme applier is from christitus tech repo : [Grub themes](https://christitus.com/bootloader-themes/)

I like to use [neovim](https://neovim.io/) with a sixel/ kitty graphic protocol support to emulate a IDE. 

---

Present configuration :
I use a hybrid desktop focused with a keyboard usage. 
Thanks to lightweight apps, the desktop uses around 1 GiB when idle and 2 GiB with two apps and chromium opened.

Foot is my terminal of choice with a custom foot.desktop file to allow passing specific app-id.

[DWL](https://codeberg.org/dwl/dwl) with custom patches for some app-id : 
    - app-id = com.Utils  : 950 * 800, centered 
    - app-id = steam.friends.list : 1100 * 800, floating
    - app-id = steam : floating
    - app-id = pop-windows : centered
    - keyboard mapping
    - auto tiling with master layout

Desktop shell is only based on [noctalia shell v5](https://docs.noctalia.dev/noctalia/):
    - notification center  \
    - lock screen \
    - idle screen \
    - background \
    - bar \
    - polkit \
    - launcher \
    - bluetooth \
    - battery \
    - wifi \
    - system monitor \
    - tailscale plugins \ 
    - calendar \
    - weather \
    - sound \

TUI :
    [bluetui](https://github.com/pythops/bluetui) |
    [wiremix](https://github.com/tsowell/wiremix) |
    [ncdu](https://github.com/rofl0r/ncdu) |
    obligatory [neofetch](https://github.com/fastfetch-cli/fastfetch) |
    [wlctl](https://github.com/aashish-thapa/wlctl) |
    [btop](https://github.com/aristocratos/btop) |

GTK / QT THEMES : 
    - [ADW](https://github.com/lassekongo83/adw-gtk3) with noctalia themes

FONTS : 
    - [IOSEVKA](https://github.com/be5invis/Iosevka) Nerd Font
    - [NOTO](https://fonts.google.com/noto) Font

ICONS : 
    - [YAMIS](https://github.com/googIyEYES/YAMIS)
    - [Bibata modern ice](https://github.com/ful1e5/Bibata_Cursor)


