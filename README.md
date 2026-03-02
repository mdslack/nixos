# NixOS Infrastructure (Dendritic + flake-parts)

This repository defines a feature-first infrastructure architecture using the dendritic pattern and `flake-parts`.

The system is organized around reusable features, composed into bundles, combined with user modules, then selected by host leaves. Outputs are generated from those leaves.

## Architecture Overview

- **Top-level model**: one top-level module graph (flake-parts), with lower-level modules stored and composed from that graph.
- **Primary composition axis**: functional concerns (base, wm, desktop, shell, vpn, browser), not host directory structure.
- **Host model**: hosts select features/bundles/users by leaf declarations.
- **Output model**: `nixosConfigurations` are built from host leaves, with stable names `<host>-<mode>`.

## Repository Structure

```text
.
├── flake.nix
├── flake.lock
├── modules/
│   ├── flake/
│   │   ├── flake-parts.nix
│   │   ├── meta.nix
│   │   ├── nixpkgs.nix
│   │   └── builders/
│   │       ├── lib.nix
│   │       └── nixos-configurations.nix
│   ├── features/
│   │   ├── base.nix
│   │   ├── inputmethod.nix
│   │   ├── terminal/
│   │   │   ├── default.nix
│   │   │   ├── alacritty.nix
│   │   │   ├── ghostty.nix
│   │   │   └── kitty.nix
│   │   ├── vpn/
│   │   │   └── proton.nix
│   │   ├── browser/
│   │   │   ├── brave.nix
│   │   │   └── pwa.nix
│   │   ├── desktop/
│   │   │   ├── cosmic.nix
│   │   │   ├── gnome.nix
│   │   │   └── kde.nix
│   │   ├── graphics/
│   │   │   ├── amd.nix
│   │   │   ├── egpu.nix
│   │   │   ├── intel.nix
│   │   │   └── nvidia.nix
│   │   ├── session/
│   │   │   ├── dms.nix
│   │   │   └── noctalia.nix
│   │   └── wm/
│   │       ├── hyprland.nix
│   │       └── niri.nix
│   ├── bundles/
│   │   ├── minimal.nix
│   │   ├── desktop/
│   │   │   ├── minimal.nix
│   │   │   ├── cosmic.nix
│   │   │   ├── gnome.nix
│   │   │   └── kde.nix
│   │   ├── session/
│   │   │   ├── dms.nix
│   │   │   └── noctalia.nix
│   │   ├── server/
│   │   │   └── minimal.nix
│   │   └── wm/
│   │       ├── hyprland.nix
│   │       └── niri.nix
│   ├── users/
│   │   └── mslack.nix
│   └── hosts/
│       ├── default.nix
│       ├── modes.nix
│       ├── toggles.nix
│       ├── framework13/
│       │   ├── default.nix
│       │   └── facter.json
│       ├── meerkat/
│       │   ├── default.nix
│       │   └── facter.json
│       └── elitedesk/
│           ├── default.nix
│           └── facter.json
└── assets/
```

## Module Domains

- **`modules/flake/*`**
  - Owns composition mechanics, package source wiring, output builders, and shared metadata.
  - No host/business feature logic.
- **`modules/features/*`**
  - Reusable feature modules.
  - A single feature file may define multiple module classes side-by-side (for example `flake.modules.nixos.<feature>` and `flake.modules.homeManager.<feature>`).
  - Examples: `base`, `features.browser.brave`, `features.browser.pwa`, `features.wm.hyprland`, `features.desktop.kde`, `features.session.dms`.
  - Must be host-agnostic.
- **`modules/bundles/*`**
  - Curated feature collections.
  - Encodes compositional intent (for example, `minimal`, `hyprland`, `shell-variants`).
- **`modules/users/*`**
  - User identity, account policy, and user-scoped composition modules.
  - Kept separate from features and bundles for clarity and ownership boundaries.
  - Can define both NixOS user declarations and Home Manager user composition.
- **`modules/hosts/*`**
  - Host leaves and host-specific overrides.
  - Declares which bundles/features/users define each `<host>-<mode>`.

## Module Classes in Feature Files

- Feature files are organized by concern, not by class-specific directories.
- It is valid and recommended to define multiple class aspects in the same file when they represent one concern.
- Typical pattern:
  - `flake.modules.nixos.<feature> = ...`
  - `flake.modules.homeManager.<feature> = ...`
  - optional later: `flake.modules.darwin.<feature> = ...`
- This is how cross-cutting concern stays co-located and easier to evolve.

## Naming and Key Conventions

- Files/dirs use kebab-case where practical.
- Aggregation points use `default.nix` where appropriate.
- Feature keys live under `flake.modules.<class>.*`.
- Host leaves are prefixed under `hosts/` for builder discovery.
- Output names are normalized to `<host>-<mode>`.

## Build Pipeline

1. `flake.nix` imports the module tree into flake-parts.
2. Top-level modules populate `flake.modules` across classes (`nixos`, `homeManager`, optional future classes).
3. Builder filters leaves by `hosts/` prefix.
4. Builder evaluates each leaf with `nixpkgs.lib.nixosSystem`.
5. Outputs are exposed as `flake.nixosConfigurations`.

## Package Source Policy

- **Baseline**: `inputs.nixpkgs` pinned to NixOS stable (`nixos-25.11`).
- **Selective newer packages**: `inputs.nixpkgs-unstable`, opt-in only.
- **DMS source**: dedicated `inputs.dms` (not nixpkgs package lookup).
- **Locking**: all sources are pinned by `flake.lock`.

## Runtime Composition Policy

- Desktop and WM stacks are composed as mutually exclusive leaves.
- Display manager/session ownership per stack:
  - `desktop-gnome` -> GNOME + GDM
  - `desktop-kde` -> Plasma 6 + SDDM
  - `desktop-cosmic` -> COSMIC + cosmic-greeter
  - `wm-hyprland` / `wm-niri` -> greetd + WM stack
- Shell variants (`shell-dms`, `shell-noctalia`) are additive leaf-level choices.

## Browser and PWA Policy

- Browser-wide managed policies are defined in browser feature scope.
- PWA force-install list and icon overrides are defined in PWA feature scope.
- Chromium-family policy paths are managed consistently.

## Dotfiles and Home Manager

- Dotfiles are managed as feature-owned Home Manager concerns, not as a separate architecture track.
- Each concern should live in one feature file where possible, with both system and user aspects together when relevant.
- Prefer declarative HM module options first (`programs.*`, `services.*`), and use file linking where needed.
- Repository-owned files can be linked via `home.file` / `xdg.configFile` from a dedicated `files/` tree.
- `modules/users/*` owns user-specific composition and selects the set of HM features for each user.

## Host Outputs

- Host and mode combinations are available as:
  - `.#framework13-<mode>`
  - `.#meerkat-<mode>`
  - `.#elitedesk-<mode>`

Common modes include:

- `minimal`
- `gnome`
- `kde`
- `cosmic`
- `hyprland`
- `niri`
- `hyprland-dms`
- `hyprland-noctalia`
- `niri-dms`
- `niri-noctalia`

## Fresh Install (Minimal ISO)

These steps assume you booted the official NixOS minimal installer ISO.

1. Bring up networking in the installer environment.

```bash
ip a
ping -c 3 nixos.org
```

If Wi-Fi is needed, use `nmtui`.

2. Partition and format the target disk (example: `/dev/nvme0n1`).

```bash
lsblk
sudo cfdisk /dev/nvme0n1
```

Recommended GPT layout:
- `1G` EFI System
- optional swap (`8G` or as desired)
- remainder as root filesystem

Format (adjust partition names if different):

```bash
sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p3
sudo mkswap -L swap /dev/nvme0n1p2
```

3. Mount target filesystem.

```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon /dev/disk/by-label/swap
```

4. Clone this repo into the target system.

```bash
sudo mkdir -p /mnt/home/mslack
sudo git clone <YOUR_REPO_URL> /mnt/home/mslack/nixos
```

5. (Recommended) Generate hardware/facter data on the target machine and update host module files.

- Generate facter report for the target host:

```bash
sudo nix run github:numtide/nixos-facter -- -o /mnt/home/mslack/nixos/modules/hosts/<host>/facter.json
```

- Generate hardware scan for reference and merge values into `modules/hosts/<host>/default.nix` as needed:

```bash
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix /tmp/<host>-hardware-configuration.nix
```

Note: this repository keeps host hardware settings in `modules/hosts/<host>/default.nix`, not `/etc/nixos/hardware-configuration.nix`. Use the copied file in `/tmp` as a temporary reference and merge only what you need.

6. Install using a specific host-mode output.

```bash
sudo nixos-install --flake /mnt/home/mslack/nixos#<host>-<mode>
```

If flakes are not enabled in the installer environment:

```bash
sudo nixos-install --flake /mnt/home/mslack/nixos#<host>-<mode> --option experimental-features "nix-command flakes"
```

7. Set password(s) before reboot (at minimum, `mslack`).

```bash
sudo nixos-enter --root /mnt -c 'passwd mslack'
sudo nixos-enter --root /mnt -c 'passwd root'
```

8. Reboot into the new system.

```bash
sudo reboot
```

After first boot, if the repo was cloned by root in the installer, fix ownership:

```bash
sudo chown -R mslack:users ~/nixos
```

9. Post-install update flow.

```bash
cd ~/nixos
git pull
sudo nixos-rebuild switch --flake .#<host>-<mode>
```

## Operational Commands

Evaluate outputs:

```bash
nix flake show --no-write-lock-file
```

Evaluate one configuration attribute:

```bash
nix eval --no-write-lock-file .#nixosConfigurations.framework13-minimal.config.system.stateVersion
```

Apply one configuration on target host:

```bash
sudo nixos-rebuild switch --flake .#framework13-minimal
```

Dry-run activation first:

```bash
sudo nixos-rebuild dry-run --flake .#framework13-minimal
```

## Design Rules

- Keep features reusable and host-agnostic.
- Keep users as a first-class domain (`modules/users/*`), not embedded ad hoc in hosts.
- Keep host-specific logic in host leaves.
- Keep package source boundaries explicit.
- Prefer composition over duplication.
- Keep `flake.nix` small and declarative.

## References

- https://github.com/mightyiam/dendritic
- https://discourse.nixos.org/t/the-dendritic-pattern/61271
- https://github.com/drupol/infra
- https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/
- https://github.com/Doc-Steve/dendritic-design-with-flake-parts
