_: {
  flake.modules.nixos.cloud =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.maestral
        pkgs."maestral-gui"
      ];
    };

  flake.modules.homeManager.cloud =
    { lib, ... }:
    {
      xdg.configFile."maestral/maestral.ini".text = ''
        [auth]
        keyring = keyring.backends.SecretService.Keyring
        token_access_type = offline

        [app]
        notification_level = 15
        log_level = 20
        update_notification_interval = 604800
        bandwidth_limit_up = 0.0
        bandwidth_limit_down = 0.0
        max_parallel_uploads = 6
        max_parallel_downloads = 6

        [sync]
        path = /home/mslack/Dropbox
        excluded_items = ['/camera uploads from chingfang', '/camera uploads', '/aed', '/git-annex-rclone', '/photos', '/apps', '/sent files', '/my axcrypt', '/tracking', '/family room', '/system images', '/aed energy logo files', '/documents', '/vault', '/paper files', '/old stuff', '/proton drive', '/chingfang']
        max_cpu_percent = 20.0
        keep_history = 604800
        upload = True
        download = True

        [main]
        version = 20.0
      '';

      home.activation.maestralAccountId = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ini_path="$HOME/.config/maestral/maestral.ini"

        if [ ! -f "$ini_path" ]; then
          exit 0
        fi

        if [ -f /etc/doppler/env ]; then
          # shellcheck disable=SC1091
          . /etc/doppler/env
        fi

        if ! command -v doppler >/dev/null 2>&1; then
          exit 0
        fi

        account_id="$(doppler secrets get MAESTRAL_ACCOUNT_ID --plain 2>/dev/null || true)"
        if [ -z "$account_id" ]; then
          exit 0
        fi

        tmp_file="$(mktemp)"
        awk -v account_id="$account_id" '
          BEGIN { in_auth = 0; inserted = 0 }
          /^\[auth\]$/ { in_auth = 1; print; print "account_id = " account_id; inserted = 1; next }
          /^\[/ { in_auth = 0 }
          in_auth && /^account_id[[:space:]]*=/ { next }
          { print }
        ' "$ini_path" > "$tmp_file"
        mv "$tmp_file" "$ini_path"
      '';
    };
}
