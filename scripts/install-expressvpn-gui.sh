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

if [[ -f "$workdir/multi_arch_installer.sh" ]]; then
  sed -i 's|exec \./"${X64_VERSION}" "\$@"|exec bash "./${X64_VERSION}" "$@"|' "$workdir/multi_arch_installer.sh"
  sed -i 's|exec \./"${ARM64_VERSION}" "\$@"|exec bash "./${ARM64_VERSION}" "$@"|' "$workdir/multi_arch_installer.sh"
fi

cd "$workdir"
exec "$BASH_BIN" ./multi_arch_installer.sh "$@"
