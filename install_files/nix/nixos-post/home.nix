{ config, pkgs, ... }:

{
  home.username = "greg";
  home.homeDirectory = "/home/greg";
  home.stateVersion = "26.11";
  
  home.packages = with pkgs; [
    # --- Terminal & CLI Utilities ---
    btop eza fastfetch fetch fd fzf lazygit less ripgrep sshs starship tmux wiremix zoxide blink
    
    # --- Desktop & GUI Apps ---
    qbittorrent localsend chromium feh ghostty gimp loupe nemo obs-studio thunderbird vlc zathura discord whatsapp-electron
    onlyoffice-desktopeditors

    # --- Wayland / TUI Tools ---
    bluetui nwg-look quickshell wofi

    # --- Utilities ---
    lutris wineWow64Packages.stable winetricks qjackctl (wineasio.overrideAttrs {
        buildInputs = [
          pkgsi686Linux.pipewire.jack
          pipewire.jack
        ];
      })


    # --- Development & Compilers ---
    cmake gcc hdf5 jdk julia luarocks mariadb ninja (lib.lowPrio ncurses) ruby tree-sitter zig

    # --- Language Specific & Editor Tools ---
    composer-require-checker mermaid-cli python3Packages.pynvim conda

    # --- Qt Development ---
    qt6.qtbase qt6.qtdeclarative qt6.qttools qt6.qtwebengine

    # --- Typography, LaTeX, & Dictionaries ---
    aspell hspell nuspell tectonic texliveFull zotero

    # --- Miscellaneous / Media ---
    android-tools ffmpeg imagemagick ueberzug

    # --- Custom Scripts ---
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];

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
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles/desktop-configs/install_files/nix/nixos-post#xii";
        };
	    profileExtra = ''	

        if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        PATH="$PATH:$HOME/.local/bin"
        fi

        if [ -d "$HOME/.config/shell/qs_bin" ] && [[ ":$PATH:" != *":$HOME/.config/shell/qs_bin:"* ]]; then
            PATH="$PATH:$HOME/.config/shell/qs_bin"
        fi

        export OMARCHY_PATH="$HOME/.config"
        export PATH

        if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec uwsm start hyprland-uwsm.desktop
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
			    "com.mitchellh.ghostty.desktop"
		    ];
	    };
    }; 

    programs.neovim = {
        enable = true;
        package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
        defaultEditor = true;
        };


    home.file.".config/" = {
   	source = ../../../config;
    	recursive = true ;
    	};

    home.file.".local/" = {
	source = ../../../local;
	recursive = true;
	};

    wayland.windowManager.hyprland.systemd.enable = false;

}

