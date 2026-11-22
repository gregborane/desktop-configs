# desktop-configs

Find my different packages and app I usually use for my config

Bash:

- aliases
- functions
- configs

Local:

- bin
- bash

Config:

- config files for rice

This is config works for Wayland compositors : Sway(fx) or Hyprland based on noctalia shell.

- Bash set up is from the [Omarchy](https://omarchy.org/) project.
- Grub theme applier is from christitus tech repo : [Grub themes](https://christitus.com/bootloader-themes/)

I like to use [neovim](https://neovim.io/) with a sixel/ kitty graphic protocol support to emulate a IDE. 

---

## Present configuration

[NIXOS](https://nixos.org/) is my os of choice and it evolves around a dendritic system.
The reproducibility stuff is not my main intesrest but the config aspect is.

I like to have in mind that the config are stored somewhere and that I won't bother remembering the command I used to configure them. If additionnal configs are required, I put them in comment at the end of the file which requires a config.

Since the "distro" is centered around this folder and not just the nix-dendritic folder, to me, it makes little sense to configure everything with nix. Thats why the symlink.sh file exists, to some extend I plan to set the .config and .local directly there but the bash way and not the nix way as it will take ages to load up (copy-copying every boot).

I also plan and making flakes-packages for the fonts/icons/themes so I wont need to store them in the configuration folder.

I use a desktop focused with a keyboard usage.
Thanks to lightweight apps, the desktop uses around 1.2 GiB (one monitor) when idle and 2 GiB with two apps and chromium opened.

[Ghostty](https://ghostty.org/) is my terminal of choice.

### [SWAY](https://swaywm.org/)

With custom patches for some app-id:

- app-id = com.Utils  : 950 * 800, centered
- app-id = steam.friends.list : 1100 * 800, floating
- app-id = steam : floating
- app-id = pop-windows : centered
- keyboard mapping
- auto tiling with master layout
- animations ans shadows are supported using swayfx a forked and custom compositor

### Desktop shell

Desktop shell is only based on [noctalia shell v5](https://docs.noctalia.dev/noctalia/):

- notification center
- lock screen
- idle screen
- background
- bar
- polkit
- launcher
- bluetooth
- battery
- wifi
- system monitor
- tailscale plugins
- calendar
- weather
- sound
- plugins are stored in ~/.config/noctalia/plugins

### TUI

- [bluetui](https://github.com/pythops/bluetui)
- [wiremix](https://github.com/tsowell/wiremix)
- [ncdu](https://github.com/rofl0r/ncdu)
- obligatory [neofetch](https://github.com/fastfetch-cli/fastfetch)
- [wlctl](https://github.com/aashish-thapa/wlctl)
- [btop](https://github.com/aristocratos/btop)

### GTK / QT THEMES

- [ADW](https://github.com/lassekongo83/adw-gtk3) with noctalia themes

### FONTS

- [SF](https://developer.apple.com/fonts/) Font
- [NOTO](https://fonts.google.com/noto) Font

### ICONS

- [WhiteSur](https://github.com/vinceliuice/WhiteSur-icon-theme)
- [Bibata modern ice](https://github.com/ful1e5/Bibata_Cursor)

---

## Softwares I like to use

- [Serein](https://github.com/ViceVerse-cz/Serein) a discord frontend in rust
- [Zapfast](https://github.com/crmne/zapfast) a whatsapp frontend in rust
- [Ungoogled Chromium](https://ungoogled-software.github.io/)
- [Zotero](https://www.zotero.org/)
- [Deck and PDF Craft](https://getartcraft.com/)
