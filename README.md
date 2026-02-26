# NixOS Workstation Starter

Flake-based NixOS starter with a full Dank Linux baseline:

- Niri compositor
- DankMaterialShell (DMS)
- DankGreeter login manager
- DankSearch service
- Home Manager integrated as a NixOS module

## Layout

- `flake.nix` - flake inputs and host definitions (`workstation`, `meerkat`, `framework`)
- `modules/workstation-base.nix` - shared baseline for all workstation-class hosts
- `modules/dev-tooling.nix` - shared developer tools module with VM toggle
- `modules/services.nix` - shared services module (Tailscale + service toggles)
- `hosts/workstation/configuration.nix` - generic workstation template host
- `hosts/meerkat/configuration.nix` - meerkat host entry
- `hosts/framework/configuration.nix` - framework host entry
- `hosts/<host>/hardware-configuration.nix` - per-host hardware profile (replace each)
- `home/mslack.nix` - user-level Home Manager config

## First steps

1. Pick a host output: `workstation`, `meerkat`, or `framework`.
2. Update host usernames in `flake.nix` if needed.
3. Rebuild:

```bash
sudo nixos-rebuild switch --flake .#<host>
```

4. Generate DMS compositor defaults (first login):

```bash
dms setup
```

You can also generate specific pieces:

```bash
dms setup binds
dms setup colors
dms setup layout
```

## Install on another machine

These steps assume you are booted into the NixOS installer ISO.

### Partition + format (ext4)

If this is a fresh disk, do this first. Example device: `/dev/nvme0n1`.

1. Identify your install disk:

```bash
lsblk
```

2. Partition the disk with `cfdisk` (GPT). Example disk: `/dev/nvme0n1`.

```bash
sudo cfdisk /dev/nvme0n1
```

Inside `cfdisk`:

- Select `gpt` when prompted for label type.
- Create partition 1: `1G`, set type to `EFI System`.
- Create partition 2: optional swap (for example `8G`), set type to `Linux swap`.
- Create partition 3: remaining space, type `Linux filesystem`.
- Choose `Write`, type `yes`, then `Quit`.

3. Format partitions (adjust partition numbers to your disk):

```bash
sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p3
sudo mkswap -L swap /dev/nvme0n1p2
```

If you skip swap, omit `mkswap` and the later `swapon` command.

4. Mount your target filesystem:

```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo swapon /dev/disk/by-label/swap
```

5. Clone this repo into `~/nixos` in the target system:

```bash
sudo git clone <YOUR_REPO_URL> /mnt/home/<username>/nixos
cd /mnt/home/<username>/nixos
```

6. Choose the host name for this machine (`workstation`, `meerkat`, or `framework`).

7. Edit `flake.nix` for this machine:

- set `hosts.<host>.username` if needed
- keep `nixpkgs` on `nixos-unstable` for Dank Linux compatibility

8. Generate hardware config, then copy it into this host path:

```bash
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/<username>/nixos/hosts/<host>/hardware-configuration.nix
```

Why this pattern: in the installer, your cloned repo path may be owned by root. Generating into `/mnt/etc/nixos` first avoids shell redirection permission issues.

If you write directly with redirection, remember `sudo cmd > file` still writes as your current user. Use root shell redirection instead:

```bash
sudo sh -c 'nixos-generate-config --show-hardware-config > /mnt/home/<username>/nixos/hosts/<host>/hardware-configuration.nix'
```

9. Install from the cloned flake path:

```bash
sudo nixos-install --flake /mnt/home/<username>/nixos#<host>
```

If the ISO environment does not have flakes enabled by default:

```bash
sudo nixos-install --flake /mnt/home/<username>/nixos#<host> --option experimental-features "nix-command flakes"
```

10. Set the user password before reboot (required to log in via greeter):

```bash
sudo nixos-enter --root /mnt -c 'passwd <username>'
```

11. Reboot into the new system:

```bash
sudo reboot
```

12. After first login, if the repo is root-owned from install-time cloning, fix ownership:

```bash
sudo chown -R "$USER":users ~/nixos
```

13. Initialize DMS config:

```bash
dms setup
```

## Update workflow

After install, future updates are:

```bash
cd ~/nixos
git pull
sudo nixos-rebuild switch --flake ~/nixos#<host>
```

You can keep `/etc/nixos` untouched when using flakes like this.

## Dotfiles location

- Keep your Home Manager-managed dotfiles repo at `~/dotfiles`.
- Keep your NixOS flake repo at `~/nixos`.
- Home Manager auto-symlinks these `~/dotfiles` paths into `~/.config` when present:
  - `dms/.config/DankMaterialShell` -> `~/.config/DankMaterialShell`
  - `lazyvim/.config/nvim` -> `~/.config/nvim`
  - `zed/.config/zed` -> `~/.config/zed`
  - `markdown/.config/markdown` -> `~/.config/markdown`
- Home Manager also links non-`~/.config` entries when present:
  - `zsh/.zshrc` -> `~/.zshrc`
  - `bash/.bashrc` -> `~/.bashrc`
  - `git/.gitconfig` -> `~/.gitconfig`
  - `ssh/.ssh/config` -> `~/.ssh/config`
  - `opencode/.opencode/opencode.jsonc` -> `~/.opencode/opencode.jsonc`
- These paths are managed as symlinks by Home Manager; keep the corresponding files/directories present in `~/dotfiles`.
- `~/.config/yazi` is managed declaratively by Home Manager (`programs.yazi`), not symlinked from dotfiles.

Example:

```bash
git clone <YOUR_DOTFILES_REPO_URL> ~/dotfiles
sudo nixos-rebuild switch --flake ~/nixos#<host>
```

## Notes

- This config follows Dank Linux NixOS flake docs by using `github:AvengeMedia/DankMaterialShell/stable`.
- DMS and DankGreeter are enabled through the flake-provided NixOS modules.
- `nixpkgs` is pinned to `nixos-unstable` for best Dank Linux compatibility.
- `system.stateVersion` and `home.stateVersion` stay at `25.11` for migration defaults.
- GNOME Keyring is enabled and wired into `greetd` PAM so tools like `gh auth login` can use system credential storage.
- Yazi Catppuccin flavor is packaged locally in `packages/yazi-flavors/catppuccin-mocha.nix` for reproducibility.

## Dev tooling module

The shared base imports `modules/dev-tooling.nix` and enables a practical default toolchain:

- `git-lfs`, `lazygit`
- `fd`, `fzf`, `ripgrep`
- `pandoc`, `nodejs`, `mermaid-cli`
- `protobuf` (`protoc`), `rustup`, `mdbook`

Yazi itself is configured in Home Manager via `programs.yazi`, including a locally packaged Catppuccin Mocha flavor.

VM stack is off by default. To enable it, set this in a host config:

```nix
workstation.devTooling.enableVmManager = true;
```

## Services module

The shared base imports `modules/services.nix` and enables Tailscale by default.

- `workstation.services.enable = true`
- `workstation.services.enableTailscale = true`
- `workstation.services.enableProtonVpn = true`

Proton VPN GUI can be launched with:

```bash
protonvpn-app
```

## Temporary utilities

When you need one-off tools for debugging or verification, prefer ephemeral shells instead of permanently adding packages to system config.

Example (`vainfo` from `libva-utils`):

```bash
nix shell nixpkgs#libva-utils -c vainfo
```

This keeps your base configuration minimal while still giving you access to diagnostics on demand.

## Next migration steps from your Fedora/Ansible setup

- Move base packages from `ansible/roles/base_system` into `environment.systemPackages`
- Move CLI/dev tools from `ansible/roles/dev_tooling` into Home Manager `home.packages`
- Move dotfiles behaviors into Home Manager modules/options
- Expand services module beyond Tailscale/ProtonVPN (other host services)
