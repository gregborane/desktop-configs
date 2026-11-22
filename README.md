# Desktop Configs

This repository contains the packages, applications, and configuration files I use for my desktop setup.

### Bash
- Aliases
- Functions
- Configuration files

### Local
- `bin`
- `bash`

### Config
- Configuration files for desktop ricing

This configuration works with Wayland compositors such as **Sway (SwayFX)** and **Hyprland**, using **Noctalia Shell**.

- The Bash setup is based on the [Omarchy](https://omarchy.org/) project.
- The GRUB theme applier comes from Chris Titus Tech's repository: [GRUB Themes](https://christitus.com/bootloader-themes/).

I enjoy using [Neovim](https://neovim.io/) with Sixel/Kitty graphics protocol support to create an IDE-like environment.

## Current Configuration

[NixOS](https://nixos.org/) is my operating system of choice, built around a dendritic configuration system.

Reproducibility isn't my main priority; what interests me most is the configuration aspect.

I like knowing that all my configurations are stored in one place, so I don't have to remember every command I used to set things up. If additional configuration steps are required, I document them in comments at the end of the relevant file.

Since my "distro" is centered around this entire repository rather than just the `nix-dendritic` directory, configuring everything through Nix doesn't make much sense to me.

That's partly why `symlink.sh` exists. Eventually, I plan to manage `.config` and `.local` directly through Bash rather than Nix, avoiding unnecessary file copying and long loading times at boot.

I also plan to create flake-based packages for fonts, icons, and themes so I won't need to store them directly in the configuration repository.

My desktop environment is designed primarily for **keyboard-driven workflows**.

Thanks to lightweight applications, the system uses approximately:
- **1.2 GiB** of RAM when idle (single monitor).
- **2 GiB** of RAM with two applications and Chromium open.

[Ghostty](https://ghostty.org/) is my terminal of choice.

### [Sway](https://swaywm.org/)

My Sway setup includes custom patches and window rules for specific application IDs:

- `app-id = com.Utils`: 950 × 800, centered.
- `app-id = steam.friends.list`: 1100 × 800, floating.
- `app-id = steam`: Floating.
- Custom keyboard mappings.
- Automatic tiling with a master layout through [swaymonad](https://github.com/nicolasavru/swaymonad).
- Animations and shadows through SwayFX, a fork of Sway with additional compositor features.

### Desktop Shell

My desktop shell is entirely based on [Noctalia Shell v5](https://docs.noctalia.dev/noctalia/), which handles:

- Notification center
- Lock screen
- Idle screen
- Wallpapers
- Status bar
- Polkit authentication
- Application launcher
- Bluetooth
- Battery management
- Wi-Fi
- System monitoring
- Tailscale plugins
- Calendar
- Weather
- Audio controls

Plugins are stored in `~/.config/noctalia/plugins`.

### Terminal Applications (TUI)

- [Bluetui](https://github.com/pythops/bluetui)
- [Wiremix](https://github.com/tsowell/wiremix)
- [ncdu](https://github.com/rofl0r/ncdu)
- The obligatory [neofetch](https://github.com/fastfetch-cli/fastfetch)
- [nmtui-go](https://github.com/doeixd/nmtui-go)
- [btop](https://github.com/aristocratos/btop)

### GTK / Qt Themes

- [adw-gtk3](https://github.com/lassekongo83/adw-gtk3), integrated with Noctalia's themes.

### Fonts

- [SF Fonts](https://developer.apple.com/fonts/)
- [Noto Fonts](https://fonts.google.com/noto)

### Icons and Cursors

- [WhiteSur Icon Theme](https://github.com/vinceliuice/WhiteSur-icon-theme)
- [Bibata Modern Ice Cursor](https://github.com/ful1e5/Bibata_Cursor)

## Software I Like to Use

- [Serein](https://github.com/ViceVerse-cz/Serein) — A Rust-based Discord frontend.
- [Zapfast](https://github.com/crmne/zapfast) — A Rust-based WhatsApp frontend.
- [Ungoogled Chromium](https://ungoogled-software.github.io/)
- [Zotero](https://www.zotero.org/)
- [Deck and PDF Craft](https://getartcraft.com/)
