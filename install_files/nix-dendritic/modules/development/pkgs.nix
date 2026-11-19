{
  flake.modules.nixos.development-packages = { pkgs, lib, ... }: {
    environment.systemPackages =
      with pkgs;
      [
              ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [ mkl ];
    users.users.greg.packages =
      with pkgs;
      [
        cmake
        stdenv
        gnumake
        gcc
        pkg-config
        sundials
        superlu
        eigen
        hdf5
        jdk
        cargo
        rustc
        julia
        lua
        nodejs
        ruby
        perl
        luarocks
        mariadb
        ninja
        (lib.lowPrio ncurses)
        tree-sitter
        zig
        go
        php
        phpPackages.composer
        elmPackages.nodejs
        sqlite
        ghostscript
        composer-require-checker
        mermaid-cli
        qt6.qtbase
        qt6.qtdeclarative
        qt6.qttools
        qt6.qtwebengine
        tectonic
        texliveFull
      ]
      ++ lib.optionals (lib.meta.availableOn pkgs.stdenv.hostPlatform conda) [ conda ];
  };
}
