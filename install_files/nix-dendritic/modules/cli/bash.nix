{
  flake.modules.nixos.bash =
    { lib, ... }:
    let
      aliases = {
        vim = "nvim";
        nano = "nvim";
        rebuild = "sudo nixos-rebuild switch --flake ~/desktop-configs/install_files/nix-dendritic#xii"; 

        clean = ''
          nix-env --delete-generations old
          sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
          sudo nix-collect-garbage --delete-old
          sudo nix-collect-garbage -d
        '';

      };

    in
    {
      programs.bash.completion.enable = true;
      programs.bash.loginShellInit = ''
        if [ "$USER" = greg ] && [ -d "$HOME/.local/bin" ]; then
          case ":$PATH:" in
            *":$HOME/.local/bin:"*) ;;
            *) export PATH="$PATH:$HOME/.local/bin" ;;
          esac
        fi
      '';
      programs.bash.interactiveShellInit = ''
        if [[ $USER == greg ]]; then
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (name: value: "alias ${name}=${lib.escapeShellArg value}") aliases
          )}
          if [[ -r "$HOME/.local/bash/rc" ]]; then source "$HOME/.local/bash/rc"; fi
          # if [[ -x "$HOME/.conda/bin/conda" ]]; then eval "$("$HOME/.conda/bin/conda" shell.bash hook)"; fi
        fi
      '';
    };
}
