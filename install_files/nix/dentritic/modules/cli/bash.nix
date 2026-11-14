{
  flake.modules.nixos.bash = {
    programs.bash.completion.enable = true;
  };

  flake.modules.homeManager.bash = {
    programs.bash = {
      enable = true;
      shellAliases = {
        vim = "nvim";
        nano = "nvim";
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles/desktop-configs/install_files/nix/dentritic#xii";

        apply = ''
          cd ~/nixos-dotfiles/desktop-configs/install_files/nix/dentritic
          git add ../../.. &&
          git commit -m "tracking changed" &&
          sudo nixos-rebuild switch --flake ~/nixos-dotfiles/desktop-configs/install_files/nix/dentritic#xii
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
      '';
      bashrcExtra = ''
        source ~/.local/bash/rc;
        eval "$(/home/greg/.conda/bin/conda shell.bash hook)";
      '';
    };
  };
}
