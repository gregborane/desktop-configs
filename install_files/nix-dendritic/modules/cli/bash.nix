
{
  flake.modules.nixos.bash =
    { lib, pkgs, ... }:
    let
      # Greg's Bash aliases
      aliases = {
        rebuild =
          "sudo nixos-rebuild switch --flake ~/desktop-configs/install_files/nix-dendritic#xii";

        clean = lib.concatStringsSep "; " [
          "nix-env --delete-generations old"
          "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old"
          "sudo nix-collect-garbage --delete-old"
          "sudo nix-collect-garbage -d"
        ];
      };

      # Declaratively managed ~/.bashrc
      bashrc = pkgs.writeText "greg-bashrc" ''
        # Managed by NixOS - do not edit directly

        [[ $- == *i* ]] || return

        # Load system-wide Bash configuration
        if [[ -r /etc/bashrc ]]; then
          source /etc/bashrc
        fi
      '';

      # Declaratively managed ~/.bash_profile
      bashProfile = pkgs.writeText "greg-bash-profile" ''
        # Managed by NixOS - do not edit directly

        if [[ -r "$HOME/.bashrc" ]]; then
          source "$HOME/.bashrc"
        fi
      '';

    in
    {
      # System-wide Bash configuration
      programs.bash = {
        enable = true;
        completion.enable = true;

        loginShellInit = ''
          if [[ "$USER" == "greg" && -d "$HOME/.local/bin" ]]; then
            case ":$PATH:" in
              *":$HOME/.local/bin:"*) ;;
              *) export PATH="$PATH:$HOME/.local/bin" ;;
            esac

              export QT_QPA_PLATFORMTHEME=qt6ct
              
              export QT_QPA_PLATFORM=wayland

              export GDK_BACKEND=wayland,x11,*

              export SDL_VIDEODRIVER=wayland,x11

              export MOZ_ENABLE_WAYLAND=1

              export ELECTRON_OZONE_PLATFORM_HINT=wayland
              export OZONE_PLATFORM=wayland

              # export LIBVA_DRIVER_NAME=nvidia
              # export __GLX_VENDOR_LIBRARY_NAME=nvidia
              
              if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
              exec sway
              fi
          fi
        '';
      };

      # Loaded at the END of /etc/bashrc
      environment.etc."bashrc.local".text = ''
        # Greg's custom Bash initialization

        if [[ $- == *i* && "$USER" == "greg" ]]; then

          # Load personal Bash configuration
          if [[ -r "$HOME/.local/bash/rc" ]]; then
            source "$HOME/.local/bash/rc"
          fi

          # Initialize Conda
          if [[ -x "$HOME/.conda/bin/conda" ]]; then
            eval "$("$HOME/.conda/bin/conda" shell.bash hook)"
          fi

          # Define Nix-managed aliases last
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList
              (name: value:
                "alias -- ${name}=${lib.escapeShellArg value}"
              )
              aliases
          )}

        fi
      '';

      # Manage Greg's Bash startup files without Home Manager
      systemd.tmpfiles.rules = [
        "L+ /home/greg/.bashrc - - - - ${bashrc}"
        "L+ /home/greg/.bash_profile - - - - ${bashProfile}"
      ];
    };
}

