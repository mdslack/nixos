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
  for candidate in "$HOME/Downloads/expressvpn-installer.run" "$HOME"/Downloads/expressvpn-linux-universal-*.run; do
    if [[ -f "$candidate" ]]; then
      INSTALLER_PATH="$candidate"
      break
    fi
  done
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

workdir="$(mktemp -d -t expressvpn-installer.XXXXXXXX)"
cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

"$BASH_BIN" "$INSTALLER_PATH" --noexec --target "$workdir"

for script in "$workdir/multi_arch_installer.sh" "$workdir/x64/install.sh" "$workdir/arm64/install.sh"; do
  if [[ -f "$script" ]]; then
    sed -i 's|^PATH="/usr/bin:/usr/sbin:/bin:/sbin"$|PATH="${PATH}:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin"|' "$script"
  fi
done

cd "$workdir"
exec "$BASH_BIN" ./multi_arch_installer.sh "$@"
