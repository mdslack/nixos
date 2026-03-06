# NixOS Infrastructure (Dendritic + flake-parts)

This repository is a reusable, host-driven NixOS flake for personal/workstation
systems. It gives you a clean way to compose one or more machines from shared
building blocks while keeping host-specific details isolated.

## What This Is

- A NixOS flake that builds complete systems as `nixosConfigurations` outputs.
- A concern-first module layout using the dendritic pattern.
- A practical setup for running multiple hosts with multiple desktop/WM modes.

## Why This Layout

- Reuse: shared concerns live once in `modules/features/*`.
- Clarity: curated stacks live in `modules/bundles/*`.
- Safety: host hardware and overrides stay in `modules/hosts/*`.
- Predictability: every deploy target has a stable name `<host>-<mode>`.
- Scale: user composition is first-class in `modules/users/*`.

## How It Works (in 60 seconds)

1. `flake.nix` loads `./modules` through `flake-parts` + `import-tree`.
2. Feature modules define reusable concerns (`network`, `editor`, `wm`, etc.).
3. Bundle modules compose features into meaningful stacks (`minimal`, `kde`,
   etc.).
4. Host leaves select mode bundles and host-specific hardware settings.
5. A builder converts leaves into outputs named `<host>-<mode>`.

You deploy by selecting one output:

```bash
sudo nixos-rebuild switch --flake .#framework13-minimal
```

## Quick Start (Existing Host)

If you already run one of the defined hosts and just want to apply changes:

```bash
git pull
nix flake show --no-write-lock-file
sudo nixos-rebuild dry-run --flake .#<host>-<mode>
sudo nixos-rebuild switch --flake .#<host>-<mode>
```

List all available outputs:

```bash
nix eval --no-write-lock-file --json .#nixosConfigurations --apply builtins.attrNames
```

## Fresh Install (NixOS Minimal ISO)

These steps assume UEFI + GPT and internet access in the installer.

1. Verify networking:

```bash
ip a
ping -c 3 nixos.org
```

2. Partition and format disk (example `/dev/nvme0n1`):

```bash
lsblk
sudo cfdisk /dev/nvme0n1
sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
sudo mkswap -L swap /dev/nvme0n1p2
sudo mkfs.ext4 -L nixos /dev/nvme0n1p3
```

3. Mount target filesystem:

```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon /dev/disk/by-label/swap
```

4. Clone this repo:

```bash
sudo mkdir -p /mnt/home/mslack
sudo git clone <YOUR_REPO_URL> /mnt/home/mslack/nixos
```

5. Generate host fact data:

```bash
sudo nix run github:numtide/nixos-facter -- -o /mnt/home/mslack/nixos/modules/hosts/<host>/facter.json
```

6. (Optional) Generate hardware reference for manual merge:

```bash
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix /tmp/<host>-hardware-configuration.nix
```

7. Install selected host-mode output:

```bash
sudo nixos-install --flake /mnt/home/mslack/nixos#<host>-<mode>
```

8. Set passwords and reboot:

```bash
sudo nixos-enter --root /mnt -c 'passwd mslack'
sudo nixos-enter --root /mnt -c 'passwd root'
sudo reboot
```

9. First boot update flow:

```bash
cd ~/nixos
git pull
sudo nixos-rebuild switch --flake .#<host>-<mode>
```

## Current Hosts and Modes

Hosts in this repo:

- `framework13`
- `meerkat`
- `elitedesk`

Modes in this repo:

- `minimal`
- `cosmic`
- `gnome`
- `kde`
- `hyprland`
- `hyprland-dms`
- `hyprland-noctalia`
- `niri`
- `niri-dms`
- `niri-noctalia`

All combinations are built as `.#<host>-<mode>`.

## Configuration Guide

Change system behavior in these files:

- `modules/hosts/modes.nix`: mode-to-bundle mapping.
- `modules/hosts/toggles.nix`: per-host switches (for example eGPU).
- `modules/hosts/<host>/default.nix`: host hardware and local overrides.
- `modules/bundles/*`: compose reusable features into stacks.
- `modules/features/*`: reusable concerns (network, shell, editor, etc.).
- `modules/users/mslack.nix`: user account + Home Manager feature selection.

## Dotfiles Strategy: Home Manager vs Out-of-Store Symlinks

This repo intentionally supports both configuration styles, chosen per concern.

When to prefer Home Manager-managed config (in-repo Nix options):

- You want reproducible, versioned, declarative config.
- You want changes reviewed and deployed via normal Nix rebuilds.
- You want less drift across hosts.
- Example: Neovim is intentionally managed through `nvf` in
  `modules/features/editor/nvf.nix` rather than symlinking `~/.config/nvim`.

When to prefer `mkOutOfStoreSymlink` to `~/dotfiles/*`:

- You want rapid iteration without rebuilding for every config tweak.
- The tool or shell workflow benefits from dynamic/live edits.
- You already maintain mature external dotfiles for that concern.
- Example: Noctalia uses out-of-store linking in
  `modules/features/session/noctalia.nix`.

How out-of-store linking behaves in this system:

- Home Manager creates a symlink into your live `~/dotfiles/*` path.
- After the link exists, editing target files takes effect immediately for most
  tools (no Nix rebuild needed for file content changes).
- You still run `nixos-rebuild`/Home Manager activation when changing module
  wiring, enabling/disabling features, or changing link targets.
- The referenced dotfiles paths must exist on each host where the feature is
  enabled.

Working rule of thumb:

- Start with Home Manager-managed config for new features.
- Use out-of-store symlinks when dynamic iteration materially improves the user
  experience for that specific concern.
- Keep the choice explicit and documented in the feature module so users can
  switch approaches case-by-case.

## Important Runtime Notes

- Desktop ownership:
  - GNOME uses GDM.
  - KDE uses SDDM.
  - COSMIC uses cosmic-greeter.
- WM ownership:
  - Hyprland and Niri use greetd-based stacks.
- Networking defaults:
  - firewall is enabled.
  - OpenSSH is enabled with password and keyboard-interactive disabled.
  - Tailscale is enabled with SSH support via `--ssh`.

## Day-2 Operations

Inspect flake outputs:

```bash
nix flake show --no-write-lock-file
```

Dry-run a target:

```bash
sudo nixos-rebuild dry-run --flake .#framework13-minimal
```

Build without switching:

```bash
sudo nixos-rebuild build --flake .#framework13-minimal
```

Switch:

```bash
sudo nixos-rebuild switch --flake .#framework13-minimal
```

## Dev Environment

Available dev shells on `x86_64-linux`:

- `default`, `go`, `rust`, `python`, `web`, `docs`, `nix`, `proto`, `full`

Example:

```bash
nix develop .#full
```

CI workflow lives in `.github/workflows/eval.yml` and runs lint/eval/critical
builds.

## Repository Map

```text
.
├── flake.nix
├── modules/
│   ├── flake/          # composition spine, package wiring, builders
│   ├── features/       # reusable concerns
│   ├── bundles/        # feature collections
│   ├── users/          # user identity + HM composition
│   ├── hosts/          # host leaves + host hardware data
│   ├── secrets/        # secret provider modules
│   └── devshells/      # flake dev shells
├── .github/workflows/
└── docs/
```

## Feature Upgrade Path (Open Items)

These are known follow-ups, kept here for transparency:

- Add optional `modules/flake/builders/lib.nix` helper utilities.
- Move `system.stateVersion` and `home.stateVersion` to canonical meta wiring
  (`modules/flake/meta.nix` exists, `modules/features/base.nix` still hardcodes
  values).
- Complete one end-to-end secrets consumer path using
  `modules/secrets/doppler.nix` (provider module exists, but active host paths
  do not consume it yet).
- Add a complete secrets bootstrap runbook for local/host onboarding.

## References

- https://github.com/mightyiam/dendritic
- https://discourse.nixos.org/t/the-dendritic-pattern/61271
- https://github.com/drupol/infra
- https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/
- https://github.com/Doc-Steve/dendritic-design-with-flake-parts
