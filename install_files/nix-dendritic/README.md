# xii · native NixOS flake

Run this flake from `install_files/nix-dendritic` in the full desktop-configs Git checkout. It exposes the AMD64 host `nixosConfigurations.xii`, a formatter, OmniSearch and checks for AMD64 and ARM64 Linux. The two disk/hardware modules belong to xii.

## Verification and rollout

From the repository root, review changes to the flake and ensure new source assets or modules are tracked. Git-backed flakes exclude untracked files.

```sh
cd install_files/nix-dendritic
nix flake check --all-systems --no-build --no-update-lock-file
nix eval --raw .#nixosConfigurations.xii.config.system.build.toplevel.drvPath
nix build --no-link .#nixosConfigurations.xii.config.system.build.toplevel
sudo nixos-rebuild boot --flake .#xii
```

Build in pure mode. On xii, after reviewing a successful build, `sudo nixos-rebuild boot --flake .#xii` queues the new generation for reboot. Keep the previous generation available in systemd-boot. The CI workflow example is in `ci-example.yml`; enabling it is a separate change under the repository root's `.github/workflows/`.
