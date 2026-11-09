{ config, pkgs, pkgs-unstable, inputs, ... }:

{

  imports = [ inputs.zapfast.homeManagerModules.default ];
  home.username = "greg";
  home.homeDirectory = "/home/greg";
  home.stateVersion = "26.05";

  home.packages = 
    # --- Stable Packages ---
    (with pkgs; [
      # Terminal & CLI Utilities
      btop-rocm eza fastfetch fd fzf lazygit less ripgrep sshs starship tmux zoxide blink dooit dex ncdu chafa
      
      # Desktop & GUI Apps
      qbittorrent localsend foot gimp loupe thunar obs-studio thunderbird vlc zathura
      onlyoffice-desktopeditors gnome-disk-utility adw-gtk3 nwg-look gsettings-desktop-schemas

      # Wayland / TUI Tools
      bluetui wofi wiremix

      # Utilities
      lutris wineWow64Packages.stable winetricks qjackctl (wineasio.overrideAttrs {
        buildInputs = [
          pkgsi686Linux.pipewire.jack
          pipewire.jack
        ];
      })

      # Development & Compilers
      cmake gcc hdf5 jdk julia lua nodejs ruby perl luarocks mariadb ninja (lib.lowPrio ncurses) tree-sitter zig go php phpPackages.composer 
      elmPackages.nodejs sqlite ghostscript

      # Language Specific & Editor Tools
      composer-require-checker mermaid-cli python3Packages.pynvim conda

      # Qt Development
      qt6.qtbase qt6.qtdeclarative qt6.qttools qt6.qtwebengine

      # Typography, LaTeX, & Dictionaries
      aspell hspell nuspell tectonic texliveFull

      # Miscellaneous / Media
      android-tools ffmpeg imagemagick ueberzug jq

      # Custom Scripts
      (pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
        text = ''exec ${pkgs.bash}/bin/bash ${pkgs.nix-search-tv.src}/nixpkgs.sh "$@"'';
      })
    ])

    ++

    # --- Unstable Packages ---
    (with pkgs-unstable; [
    ])

    ++

    [
        (import ./zotero.nix { inherit pkgs; })
        inputs.serein.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
   
  programs.zapfast.enable = true;
  wayland.systemd.target = "dwl-session.target";
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = ../../config/noctalia/noctalia-full-config.toml;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user = {
      name = "gregborane";
      email = "madaradellac@gmail.com";
    };
  };

  programs.bash = {   
    enable = true;
    shellAliases = {
      vim = "nvim";
      nano = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles/desktop-configs/install_files/nix#xii";

      apply = ''
        cd ~/nixos-dotfiles/desktop-configs/install_files/nix
        git add ../.. &&
        git commit -m "tracking changed" &&
        sudo nixos-rebuild switch --flake ~/nixos-dotfiles/desktop-configs/install_files/nix#xii
      '';

      clean = ''
        nix-env --delete-generations old
        sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
        sudo nix-collect-garbage --delete-old
        sudo nix-collect-garbage -d
        '';

    };

    profileExtra = ''
      if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        PATH="$PATH:$HOME/.local/bin"
      fi

      export PATH
      export QT_QPA_PLATFORMTHEME=qt6ct
      export QT_QPA_PLATFORM=wayland
      
      export GDK_BACKEND=wayland,x11,*
      
      export SDL_VIDEODRIVER=wayland,x11
      
      export MOZ_ENABLE_WAYLAND=1
      
      export ELECTRON_OZONE_PLATFORM_HINT=wayland
      export OZONE_PLATFORM=wayland
      


      # export LIBVA_DRIVER_NAME=nvidia
      # export __GLX_VENDOR_LIBRARY_NAME=nvidia

      if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && [ ! -e "$HOME/.local/state/skip-dwl" ]; then
        xii-dwl || echo "dwl exited with status $?; remaining on tty1" >&2
      fi
    '';

    bashrcExtra = ''
      source ~/.local/bash/rc;
      eval "$(/home/greg/.conda/bin/conda shell.bash hook)";
    '';
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "foot.desktop"
      ];
    };
  };     

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    sideloadInitLua = true;
  };
}
