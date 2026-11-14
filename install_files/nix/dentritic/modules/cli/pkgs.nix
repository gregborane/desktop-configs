{
  flake.modules.nixos.cli-packages = { lib, pkgs, ... }: {
    environment.systemPackages =
      with pkgs;
      [
        fuse3
        sshfs
        wget
        curl
        wol
        openssl
        inotify-tools
        unrar
        p7zip
        unzip
        zip
        innoextract
        killall
        haskellPackages.gio
        nix-index
        appimage-run
      ]
      ++ lib.optionals (lib.meta.availableOn pkgs.stdenv.hostPlatform rar) [ rar ];
  };

  flake.modules.homeManager.cli-packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      eza
      fastfetch
      fd
      fzf
      less
      ripgrep
      starship
      zoxide
      blink
      dex
      chafa
      android-tools
      ffmpeg
      imagemagick
      ueberzug
      jq
      aspell
      hspell
      nuspell
    ];
  };
}
