#!/usr/bin/env bash
set -euo pipefail

INSTALLER_PATH="${1:-$HOME/Downloads/expressvpn-installer.run}"

if [[ ! -f "$INSTALLER_PATH" ]]; then
  printf 'ExpressVPN installer not found: %s\n' "$INSTALLER_PATH" >&2
  printf 'Download the Linux GUI installer and try again.\n' >&2
  exit 1
fi

if [[ -z "${WAYLAND_DISPLAY:-}" && -z "${DISPLAY:-}" ]]; then
  printf 'No graphical session detected. Run this from your desktop session.\n' >&2
  exit 1
fi

chmod +x "$INSTALLER_PATH"

printf 'Running installer: %s\n' "$INSTALLER_PATH"
printf 'You may be prompted for your sudo password.\n'
if command -v bash >/dev/null 2>&1; then
  exec sudo "$(command -v bash)" "$INSTALLER_PATH"
fi

if command -v sh >/dev/null 2>&1; then
  exec sudo "$(command -v sh)" "$INSTALLER_PATH"
fi

printf 'No POSIX shell found in PATH for installer execution.\n' >&2
exit 1
