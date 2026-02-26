#!/usr/bin/env bash
set -euo pipefail

BASH_BIN="$(command -v bash || true)"
if [[ -z "$BASH_BIN" ]]; then
  printf 'bash not found in PATH.\n' >&2
  exit 1
fi

if [[ $# -gt 0 && -f "$1" ]]; then
  INSTALLER_PATH="$1"
  shift
else
  INSTALLER_PATH=""
  shopt -s nullglob
  universal_candidates=("$HOME"/Downloads/expressvpn-linux-universal-*.run)
  shopt -u nullglob

  if (( ${#universal_candidates[@]} > 0 )); then
    INSTALLER_PATH="$(ls -1t "${universal_candidates[@]}" | head -n1)"
  elif [[ -f "$HOME/Downloads/expressvpn-installer.run" ]]; then
    INSTALLER_PATH="$HOME/Downloads/expressvpn-installer.run"
  fi
fi

if [[ -z "$INSTALLER_PATH" || ! -f "$INSTALLER_PATH" ]]; then
  printf 'ExpressVPN installer not found in ~/Downloads.\n' >&2
  printf 'Pass a path explicitly: %s /path/to/installer.run\n' "$0" >&2
  exit 1
fi

if [[ -z "${WAYLAND_DISPLAY:-}" && -z "${DISPLAY:-}" ]]; then
  printf 'No graphical session detected. Run this from your desktop session.\n' >&2
  exit 1
fi

chmod +x "$INSTALLER_PATH"

printf 'Running installer: %s\n' "$INSTALLER_PATH"
printf 'You may be prompted for your sudo password.\n'

if ! "$BASH_BIN" "$INSTALLER_PATH" --check >/dev/null 2>&1; then
  printf 'Installer integrity check failed (unexpected archive size or checksum mismatch).\n' >&2
  printf 'Re-download the installer and try again.\n' >&2
  exit 1
fi

workdir="$(mktemp -d -t expressvpn-installer.XXXXXXXX)"
cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

"$BASH_BIN" "$INSTALLER_PATH" --noexec --target "$workdir"

for script in "$workdir/multi_arch_installer.sh" "$workdir/x64/install.sh" "$workdir/arm64/install.sh"; do
  if [[ -f "$script" ]]; then
    sed -i '1 s|^#!/bin/bash$|#!/usr/bin/env bash|' "$script"
    sed -i 's|^PATH="/usr/bin:/usr/sbin:/bin:/sbin"$|PATH="${PATH}:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin"|' "$script"
  fi
done

# Patch hardcoded FHS binary paths used by installer scripts.
mapfile -t script_files < <(find "$workdir" -type f -name "*.sh")
for cmd in bash sh cp mv rm mkdir ln chmod chown chgrp sed awk grep cat head tail wc expr dd mktemp dirname uname id tee touch killall pgrep ps systemctl service update-rc.d rc-service rc-update setcap getent groupadd; do
  resolved="$(command -v "$cmd" || true)"
  if [[ -n "$resolved" ]]; then
    for script in "${script_files[@]}"; do
      sed -i "s|/bin/$cmd|$resolved|g" "$script"
      sed -i "s|/usr/bin/$cmd|$resolved|g" "$script"
      sed -i "s|/sbin/$cmd|$resolved|g" "$script"
      sed -i "s|/usr/sbin/$cmd|$resolved|g" "$script"
    done
  fi
done

# Ensure sudo uses NixOS PATH when installer escalates commands.
for script in "$workdir/x64/install.sh" "$workdir/arm64/install.sh"; do
  if [[ -f "$script" ]]; then
    sed -i 's|if ! sudo "\$@"; then|if ! sudo env "PATH=$PATH" "$@"; then|' "$script"
    sed -i 's|sudo "\$@"|sudo env "PATH=$PATH" "$@"|' "$script"
    sed -i 's|_sudo setcap |_sudo_optional setcap |' "$script"
    sed -i 's|migrateXVLegacySettings \|\| true|true # skip legacy settings migration on NixOS|' "$script"
    sed -i 's|_sudo_optional ln -s "${ctlExecutablePath}" "${ctlSymlinkPath}" \|\| true|true # skip ctl symlink on NixOS|' "$script"
  fi
done

if [[ -f "$workdir/multi_arch_installer.sh" ]]; then
  sed -i 's|exec \./"${X64_VERSION}" "\$@"|exec bash "./${X64_VERSION}" "$@"|' "$workdir/multi_arch_installer.sh"
  sed -i 's|exec \./"${ARM64_VERSION}" "\$@"|exec bash "./${ARM64_VERSION}" "$@"|' "$workdir/multi_arch_installer.sh"
fi

cd "$workdir"

force_dep_flag="--force-dependencies"
gui_flag="--gui"
for arg in "$@"; do
  if [[ "$arg" == "--force-dependencies" ]]; then
    force_dep_flag=""
  fi
  if [[ "$arg" == "--gui" || "$arg" == "--headless" ]]; then
    gui_flag=""
  fi
done

if [[ -n "$force_dep_flag" ]]; then
  if [[ -n "$gui_flag" ]]; then
    exec "$BASH_BIN" ./multi_arch_installer.sh "$force_dep_flag" "$gui_flag" "$@"
  fi
  exec "$BASH_BIN" ./multi_arch_installer.sh "$force_dep_flag" "$@"
fi

if [[ -n "$gui_flag" ]]; then
  exec "$BASH_BIN" ./multi_arch_installer.sh "$gui_flag" "$@"
fi

exec "$BASH_BIN" ./multi_arch_installer.sh "$@"
