{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  home.username = "greg";
  home.homeDirectory = "/home/greg";
  home.stateVersion = "26.05";

  home.packages = 
    # --- Stable Packages ---
    (with pkgs; [
      # Terminal & CLI Utilities
      btop eza fastfetch fd fzf lazygit less ripgrep sshs starship tmux zoxide blink dooit dex
      
      # Desktop & GUI Apps
      qbittorrent localsend ghostty gimp loupe thunar obs-studio thunderbird vlc zathura legcord zapzap
      onlyoffice-desktopeditors

      # Wayland / TUI Tools
      bluetui nwg-look quickshell wofi wiremix

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
        text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      })
    ])

    ++

    # --- Unstable Packages ---
    (with pkgs-unstable; [
        ungoogled-chromium        
    ])

    ++

    [
        (import ./zotero.nix { inherit pkgs; })

    ];


  programs.noctalia = {
    enable = true;
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

      if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec uwsm start hyprland-uwsm.desktop &> /dev/null
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
    
  programs.ungoogle-chromium = {
  enable = true;

  homepageLocation = "http://127.0.0.1:8087/";

  # Default search engine
  defaultSearchProviderEnabled = true;
  defaultSearchProviderName = "Local Search";
  defaultSearchProviderSearchURL =
    "http://127.0.0.1:8087/search?q={searchTerms}";

  extensions = [
    # Existing extensions
    "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx" # Dark Reader
    "aapbdbdomjkkjkaonfhkkikfgjllcleb;https://clients2.google.com/service/update2/crx" # Google Translate

    # uBlock Origin
    "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"

    # SponsorBlock
    "mnjggcdmjocbbbhaepdhchncahnbgone;https://clients2.google.com/service/update2/crx"

    # YouTube Shorts blocker
    # Add the chosen extension ID here.

    # Vertical tabs / lateral tab bar
    # Add the chosen extension ID here.
  ];
};

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    sideloadInitLua = true;
  };
  wayland.windowManager.hyprland.systemd.enable = false;
}
