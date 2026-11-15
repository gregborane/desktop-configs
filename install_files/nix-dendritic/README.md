# xii · native NixOS flake

Run this flake from `install_files/nix-dendritic` in the full desktop-configs Git checkout. It exposes the AMD64 host `nixosConfigurations.xii`, a formatter, OmniSearch and checks for AMD64 and ARM64 Linux. The two disk/hardware modules belong to xii.

## Feature ownership

The flake-parts modules extension and import-tree discover the definitions in `modules/`. Each feature publishes a NixOS module; `modules/hosts/xii.nix` selects the features. To add an application with settings, define its NixOS module in the appropriate category and import it in xii. Installation-only entries go in the category's `pkgs.nix`. System tools use `environment.systemPackages`; Greg's personal applications use `users.users.greg.packages`.

| Feature | Native owner |
| --- | --- |
| Bash, Sway | Bash system startup snippets guarded for Greg. The tty1 Bash login starts Sway with the existing Wayland variables. Swaymonad, portals and XWayland remain in the Sway feature. The rebuild/apply aliases target this flake. |
| Noctalia | The pinned upstream NixOS module installs the shell and defines its graphical-session user service. Greg's service and the login session use `NOCTALIA_CONFIG_HOME=/etc/xdg`. The full TOML is validated during the build and exposed as `/etc/xdg/noctalia/config.toml` alongside plugins and palettes. These declarative defaults are read-only. Noctalia's state directory stays per-user. |
| Git | Native Git and LFS configuration. Git includes a per-home identity file, provisioned for Greg by tmpfiles. User Git configuration retains normal precedence. |
| Neovim | Greg's package is the locked nightly build wrapped with Python support. It loads the existing user init.lua. |
| Ghostty | Greg's package and the native xdg-terminal-exec default using Ghostty's installed desktop ID, `com.mitchellh.ghostty.desktop`. |
| Other user applications | Zotero retains the 10.0.2 pin. ZapFast keeps the upstream package and its own settings. Serein is installed where upstream publishes a package. Thunar, WineASIO and the ns wrapper retain their feature definitions. |
| System | xii keeps its existing boot, storage, AMD, TLP, networking, audio, service and system package features. The optional Hyprland feature is available for explicit selection. Sway remains active. |

## Migration from the previous Home Manager integration

The flake has no Home Manager input, home configuration or Home Manager activation service. NixOS now owns the package profiles and generated system configuration. The NixOS state version remains 26.05. Existing dotfile links for Sway, Neovim, Bash, plugins and other external configuration still need to point at the repository, as in the previous setup.

The old flake was one directory deeper. Both the Plymouth source and the Noctalia source now resolve through the Git snapshot at the new depth. Noctalia explicitly reads the tracked regular file `config/noctalia/noctalia-full-config.toml`. The repository's old `config/noctalia/config.toml` is an absolute symlink into a previous Home Manager generation.

Removing the module does not clean files left in Greg's home by earlier generations. Before the first new login, inspect `~/.bashrc`, `~/.bash_profile`, `~/.profile`, `~/.config/git/config`, `~/.config/xdg-terminals.list` and `~/.config/systemd/user` for old Home Manager links. Also check user-level graphical-session target wants for a stale Noctalia unit. Stale files can shadow system defaults or run old startup hooks twice. Move aside only confirmed generated links, keep backups, and preserve personal files and repository dotfile links. The new configuration performs no home-directory cleanup.

## Verification and rollout

From the repository root, review changes to the flake and ensure new source assets or modules are tracked. Git-backed flakes exclude untracked files.

```sh
cd install_files/nix-dendritic
nix flake check --all-systems --no-build --no-update-lock-file
nix eval --raw .#nixosConfigurations.xii.config.system.build.toplevel.drvPath
nix build --no-link .#nixosConfigurations.xii.config.system.build.toplevel
```

Build in pure mode. On xii, after reviewing a successful build, `sudo nixos-rebuild boot --flake .#xii` queues the new generation for reboot. Keep the previous generation available in systemd-boot. The CI workflow example is in `ci-example.yml`; enabling it is a separate change under the repository root's `.github/workflows/`.
