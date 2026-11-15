
{
  flake.modules.nixos.bash =
    { lib, pkgs, ... }:
    let
      aliases = {
        rebuild =
          "sudo nixos-rebuild switch --flake ~/desktop-configs/install_files/nix-dendritic#xii";

        clean = ''
          nix-env --delete-generations old
          sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
          sudo nix-collect-garbage --delete-old
          sudo nix-collect-garbage -d
        '';
      };

      # User Bash configuration
      bashrc = pkgs.writeText "greg-bashrc" ''
        # Managed by NixOS - do not edit directly

        [[ $- == *i* ]] || return

        if [[ -r /etc/bashrc ]]; then
          source /etc/bashrc
        fi
      '';

      bashProfile = pkgs.writeText "greg-bash-profile" ''
        # Managed by NixOS - do not edit directly

        if [[ -r "$HOME/.bashrc" ]]; then
          source "$HOME/.bashrc"
        fi
      '';

    in
    {
      programs.bash = {
        enable = true;
        completion.enable = true;

        loginShellInit = ''
          if [ "$USER" = greg ] && [ -d "$HOME/.local/bin" ]; then
            case ":$PATH:" in
              *":$HOME/.local/bin:"*) ;;
              *) export PATH="$PATH:$HOME/.local/bin" ;;
            esac
          fi
        '';

        interactiveShellInit = ''
          if [[ "$USER" == greg ]]; then
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList
                (name: value:
                  "alias -- ${name}=${lib.escapeShellArg value}"
                )
                aliases
            )}

      		source $HOME/.local/bash/rc;
      		eval "$($HOME/.conda/bin/conda shell.bash hook)"
	  fi
        '';
      };

      # Declaratively create Greg's startup files
      systemd.tmpfiles.rules = [
        "L+ /home/greg/.bashrc - - - - ${bashrc}"
        "L+ /home/greg/.bash_profile - - - - ${bashProfile}"
      ];
    };
}

