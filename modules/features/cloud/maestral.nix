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
    { config, lib, ... }:
    {
      xdg.configFile."maestral" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/maestral";
        recursive = true;
      };

      home.activation.maestralAccountId = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ini_path="$HOME/.config/maestral/maestral.ini"

        if [ -f "$ini_path" ]; then
          if [ -f /etc/doppler/env ]; then
            # shellcheck disable=SC1091
            . /etc/doppler/env
          fi

          if command -v doppler >/dev/null 2>&1; then
            account_id="$(doppler secrets get MAESTRAL_ACCOUNT_ID --plain 2>/dev/null || true)"
          else
            account_id=""
          fi

          if [ -n "$account_id" ]; then
            tmp_file="$(mktemp)"
            awk -v account_id="$account_id" '
          BEGIN { in_auth = 0; inserted = 0 }
          /^\[auth\]$/ { in_auth = 1; print; print "account_id = " account_id; inserted = 1; next }
          /^\[/ { in_auth = 0 }
          in_auth && /^account_id[[:space:]]*=/ { next }
          { print }
            ' "$ini_path" > "$tmp_file"
            mv "$tmp_file" "$ini_path"
          fi
        fi
      '';
    };
}
