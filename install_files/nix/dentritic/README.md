# The xii desktop

The canonical Git-backed flake is `install_files/nix/dentritic#xii`. Its only physical host is xii (AMD64). The two Linux systems each expose a formatter, OmniSearch and checks. The ARM64 outputs do not describe a machine or its disks.

## Composition

`flake.nix` imports the flake-parts modules extension and applies import-tree to `modules/`. Files there publish named, typed NixOS and Home Manager modules. `modules/hosts/xii.nix` selects the system features, imports the two hardware/storage files explicitly and connects Home Manager to Greg's profile using the host's package set. `modules/users/greg.nix` selects the user features. Both state versions are 26.05.

To add a configured application, publish `flake.modules.nixos.<name>`, `flake.modules.homeManager.<name>`, or both from a file under the relevant category. Select the published module in the host or user imports. For installation alone, add the package to the corresponding category's system or home list. For another physical machine, add its own generated files under `hosts/<name>/` and a composition under `modules/hosts/`. Select hardware features there. The optional Hyprland module enables XWayland and sets `withUWSM = false` when imported. xii selects the Sway system and home features, including its tty1 launch.

## Migration and package inventory

Paths in the left column refer to baseline commit `783bb44a462c4c61b280ea39bf8692bc4839e563` under `install_files/nix/`. Destinations starting with a category refer to `dentritic/modules/`.

| Baseline owner and items | New owner and scope |
|---|---|
| flake.nix inputs, outputs and lock | dentritic/flake.nix and flake.lock; hosts/xii composes NixOS with integrated Home Manager, shared packages, user packages and the backup suffix. |
| hardware-configuration.nix; storage-configuration.nix | dentritic/hosts/xii/ contains byte-identical files for kernel modules, microcode, both LUKS UUIDs, LVM, root/home/EFI mounts and swap. |
| configuration.nix boot and memory | hardware/xii-boot owns the latest kernel, boot flags, THP, EFI/systemd-boot, initrd, Plymouth theme substitution, zswap and zram. |
| configuration.nix hardware and TLP | hardware/amd owns firmware, graphics, OpenCL and the three system ROCm packages. hardware/power owns both power profiles, TLP settings and acpi/acpid/brightnessctl. hardware/bluetooth enables Bluetooth. |
| configuration.nix PipeWire | hardware/audio owns the system PipeWire/JACK and ALSA packages, WirePlumber, Pulse, 32-bit ALSA and clock/quantum settings. |
| configuration.nix network, time, login, compatibility | hosts/xii owns NetworkManager and scan policy, firewall, IPv6, all static mappings, timezone, SSH allowlist, tty autologin and system.stateVersion. |
| configuration.nix services, fonts and permissions | services/{polkit,ssh,tailscale} own the graphical agent, disabled SSH server and settings, and Tailscale. desktop/integration owns keyring, udisks2, upower, fprintd, fstrim, GVfs, tumbler and printing. desktop/fonts owns both Noto packages. users/greg owns account, groups and user-scoped tree. |
| configuration.nix Nix and development packages | core/nix owns flakes, nix-command, nix-ld and unfree policy. development/pkgs owns system toolchain, scientific libraries and MKL. |
| configuration.nix networking tools, filesystems, archive and miscellaneous packages | cli/pkgs owns the system utilities including gio, nix-index and appimage-run. cli/git also keeps Git on the system PATH. |
| configuration.nix Sway, portals, gamescope and desktop tools; home.nix Wayland login | desktop/sway owns Swaymonad, XWayland, GTK wrapper, wlr/GTK portals, environment exports and conditional tty1 exec. desktop/pkgs owns gamescope and system desktop tools, plus Greg's desktop utilities. |
| browser.nix | gui/chromium owns system ungoogled Chromium with Widevine, policies, initial preferences, bookmark tree and HTML export. Existing preference keys and bookmarks are preserved verbatim. |
| home.nix home identity and Git | users/greg owns home path, state version and Git identity. cli/git owns Home Manager Git and LFS. |
| home.nix Bash and scripts | cli/bash owns system completions, user aliases, PATH, rc and Conda hook. cli/ns owns the fzf/nix-search-tv wrapper. |
| home.nix Noctalia, Neovim, Serein and Zapfast | desktop/noctalia owns settings and its systemd integration. tui/neovim owns nightly, Python, pynvim and init.lua sideload. gui/serein and gui/zapfast retain their respective flake integrations. |
| home.nix configured GUI packages | gui/thunar owns the two plugins. gui/wine owns Wine, Winetricks and the WineASIO JACK override. gui/ghostty owns the terminal and original terminal-exec preference. |
| home.nix other stable packages | cli/pkgs, tui/pkgs, gui/pkgs, desktop/pkgs and development/pkgs own Greg's command-line/media/dictionary tools, terminal tools, desktop apps, desktop integration and language/Qt/TeX tooling respectively. Names are enumerated in those lists. |
| zotero.nix | gui/zotero owns the home package, using locked revision 131cf0f911b8fee10ae531f91e391db3e74672a6 and an exact 10.0.2 assertion. |
| omnisearch.nix and the duplicate raw migration file | services/omnisearch owns Beaker, the OmniSearch build flags, DuckDuckGo Lite POST handling, install layout, generated INI, bind mounts, cache lifetimes, dynamic user, hardening and restart policy. hosts/xii selects 127.0.0.1:8087. |
| partial dentritic tree | Empty placeholders removed or populated. Host networking and Bluetooth supersede the malformed drafts. core/checks supplies validation; desktop/hyprland supplies optional future activation. No separate legacy home/ or system/ module directories existed at this revision. |

## Behavior and dependency decisions

- The stable and unstable revisions and all existing dependency nodes come from the working legacy lock. Home Manager, Swaymonad and Noctalia follow stable. Serein and Zapfast keep their unstable relationship. Neovim nightly retains its own package set. The root reuses its already-locked flake-parts. The incomplete flake's unused wrapper framework and the empty unstable home package list had no active consumers.
- CMake, GCC and HDF5 were directly installed in both profiles. They now come from the system profile for xii. Greg keeps access via the system PATH; the three direct links in Greg's package profile disappear. Git retains both the system command and Home Manager program integration.
- MKL, the ROCm btop variant, Wine and the dual-architecture WineASIO override are selected on AMD64. RAR and Conda consult pinned package metadata. AMD hardware modules are explicitly selected by xii. The pinned Serein input has no ARM64 Linux package, so its feature contributes a package only on systems published by upstream. The ARM64 checks evaluate Greg's Home Manager package list against platform metadata and exercise the optional Hyprland settings. They create no additional physical host.
- OmniSearch's legacy `substituteInPlace --replace-fail` targeted a call containing `full_url` that occurs zero times in the locked source. Building that derivation from source would stop at the patch step. Revision `e72fadc791163ac7fd0eabb2aceec50942482ddd` already routes the DDG engine through `configure_ddg_request`, strips the query string and sends the encoded form using `CURLOPT_COPYPOSTFIELDS`. The refactor removes that stale substitution. It preserves the locked C source, libxml2 include flag, Beaker build, runtime dependencies and service configuration.
- The rebuild/apply aliases now target the nested flake. The apply alias retains the original repository-wide staging scope. The existing clean alias prunes generations, so avoid it while retaining a rollback generation.
- The repository's symlink.sh remains responsible for the live config and local directories, including Sway, Ghostty, Neovim and Bash. The Nix sources for Plymouth and Noctalia resolve through the parent Git snapshot. Use the full Git checkout when evaluating this subdirectory. An isolated copy of dentritic lacks those assets.

## Review, build and manually activate

Run the following from the repository root on a machine with flakes enabled. Keep the previous boot generation available.

```bash
git status --short
cd install_files/nix/dentritic
nix flake metadata --no-update-lock-file
nix flake show --all-systems --no-update-lock-file
nix flake check --all-systems --no-build --no-update-lock-file
nix eval --raw .#nixosConfigurations.xii.config.system.build.toplevel.drvPath
nix build --no-link .#nixosConfigurations.xii.config.system.build.toplevel
nix flake check --no-update-lock-file
```

Run native checks on each architecture, or use configured remote builders for `nix flake check --all-systems`. The x86 check includes the full host closure (including TeX, scientific libraries and the desktop). Allow adequate build storage. To check formatting, run `nix fmt -- --check flake.nix modules`. Machine-generated hardware and its companion storage file are deliberately preserved byte-for-byte.

For manual activation **on xii only**, after a successful build and review, record `readlink -f /run/current-system`. Use `sudo nixos-rebuild boot --flake .#xii` to queue the generation for the next boot, or `sudo nixos-rebuild switch --flake .#xii` to activate immediately. Test disk unlock, mounts, tty1 Sway startup, audio, portals and the local search service on the actual machine.

For runtime rollback, choose the previous NixOS generation in systemd-boot. From a running installation where the immediately preceding generation is the desired one, use `sudo nixos-rebuild switch --rollback`. To inspect or build the original Git configuration independently, from the repository root use `git worktree add --detach ../desktop-configs-baseline 783bb44a462c4c61b280ea39bf8692bc4839e563` and build `../desktop-configs-baseline/install_files/nix#nixosConfigurations.xii.config.system.build.toplevel` with `nix build --no-link`.

## CI

The example in ci-example.yml runs each native architecture independently. To activate it separately, place a copy at the repository root under .github/workflows/. CI availability depends on runner architecture, storage and caches.

## Validation record

The starting checkout and remote HEAD both resolved to `783bb44a462c4c61b280ea39bf8692bc4839e563`. Validation used Nix 2.28.5 and nixfmt 1.5.0. Every versioned change is under `install_files/nix/`.

| Command or comparison | Observed result |
|---|---|
| `nix-instantiate --parse` on each of the 37 Nix files; `nixfmt --check` on the flake and discovered modules | Passed. The two copied host files also matched their baseline Git blobs byte-for-byte. |
| `nix flake show --all-systems --no-update-lock-file` | Passed. Both Linux systems expose OmniSearch, formatter and checks. xii is the only NixOS host. |
| `nix flake check --all-systems --no-build --no-update-lock-file` | Passed, including the xii system derivation, integrated Home Manager, both Linux outputs, optional Hyprland with XWayland/UWSM settings, Zotero pin/version, tracked external assets and ARM home package platform checks. Nix 2.28 reports the custom `modules` flake output as unknown; the explicit module imports and assertions evaluated. |
| `nix eval --raw .#nixosConfigurations.xii.config.system.build.toplevel.drvPath` | Passed. Produced a NixOS 26.05 xii derivation. Its hash is store-prefix dependent in this environment. |
| Baseline and migrated NixOS/Home Manager evaluation, compared as JSON | All 208 system package entries matched by name and version, including multiplicity. The 95 original home entries became 92; only the three system duplicates documented above were removed. Bookmarks, Chromium preferences, disk mappings and mounts, kernel flags, host mappings, IPv6, TLP, PipeWire latency, SSH settings, Git settings, groups, state versions, Sway and the OmniSearch server settings matched. |
| Direct service and login comparison | Plymouth derivations, polkit user service configuration and Bash rc matched. Login profile text gained one blank line between PATH setup and the Wayland exports. OmniSearch's unit retained its directives and bind layout; the package store path changed after correcting the stale patch. |
| Lock comparison; ARM Home Manager evaluation | All 17 pre-existing non-root lock nodes matched exactly. Zotero evaluated at 10.0.2. All 85 entries of Greg's standalone ARM Home Manager package list reported ARM64 availability. Actual ARM builds were not run. |
| Native source build of pinned Beaker and OmniSearch | Both compiled and linked using the workspace C toolchain. A temporary loopback instance loaded 14 locales and returned HTTP 200 for the homepage. It shut down after the test. The smoke test used the locked source and host dependency libraries; Nix closure realization remains unverified. |
| Nix build attempts | The available store used a workspace-specific prefix. Nix rejected the standard binary cache for that prefix. The initial formatter build could not create its default temporary build directory. With a writable build directory and the remote hook disabled, the x86 OmniSearch and xii build attempts reached dependency builds. The xii attempt planned over 31,000 derivations. Bounded 120-second attempts ended before realization. The full build-enabled all-systems check, physical boot, disk unlock, graphical login and hardware runtime behavior remain unverified. |

An initial concurrent deep evaluation exited with status 137. The isolated all-systems evaluation subsequently completed. CI is provided as an example under this flake. No deployment or generation activation was performed.

## Final tree

~~~text
dentritic
├── README.md
├── ci-example.yml
├── flake.lock
├── flake.nix
├── hosts
│   └── xii
│       ├── hardware-configuration.nix
│       └── storage-configuration.nix
└── modules
    ├── cli
    │   ├── bash.nix
    │   ├── git.nix
    │   ├── ns.nix
    │   └── pkgs.nix
    ├── core
    │   ├── checks.nix
    │   └── nix.nix
    ├── desktop
    │   ├── fonts.nix
    │   ├── hyprland.nix
    │   ├── integration.nix
    │   ├── noctalia.nix
    │   ├── pkgs.nix
    │   └── sway.nix
    ├── development
    │   └── pkgs.nix
    ├── gui
    │   ├── chromium.nix
    │   ├── ghostty.nix
    │   ├── pkgs.nix
    │   ├── serein.nix
    │   ├── thunar.nix
    │   ├── wine.nix
    │   ├── zapfast.nix
    │   └── zotero.nix
    ├── hardware
    │   ├── amd.nix
    │   ├── audio.nix
    │   ├── bluetooth.nix
    │   ├── power.nix
    │   └── xii-boot.nix
    ├── hosts
    │   └── xii.nix
    ├── services
    │   ├── omnisearch.nix
    │   ├── polkit.nix
    │   ├── ssh.nix
    │   └── tailscale.nix
    ├── tui
    │   ├── neovim.nix
    │   └── pkgs.nix
    └── users
        └── greg.nix
~~~
