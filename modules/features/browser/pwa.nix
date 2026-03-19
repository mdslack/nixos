_: let
  pwaInstallForceList = [
    {
      url = "https://acrobat.adobe.com";
      default_launch_container = "window";
      custom_name = "Adobe Acrobat";
    }
    {
      url = "https://aedenergy.app.box.com";
      default_launch_container = "window";
      custom_name = "Box";
    }
    {
      url = "https://chatgpt.com";
      default_launch_container = "window";
      custom_name = "ChatGPT";
    }
    {
      url = "https://dropbox.com";
      default_launch_container = "window";
      custom_name = "Dropbox";
    }
    {
      url = "https://excel.cloud.microsoft";
      default_launch_container = "window";
      custom_name = "Excel";
    }
    {
      url = "https://powerpoint.cloud.microsoft";
      default_launch_container = "window";
      custom_name = "PowerPoint";
    }
    {
      url = "https://teams.microsoft.com";
      default_launch_container = "window";
      custom_name = "Microsoft Teams";
    }
    {
      url = "https://word.cloud.microsoft";
      default_launch_container = "window";
      custom_name = "Word";
    }
    {
      url = "https://outlook.office.com";
      default_launch_container = "window";
      custom_name = "Outlook";
    }
    {
      url = "https://calendar.proton.me";
      default_launch_container = "window";
      custom_name = "Proton Calendar";
    }
    {
      url = "https://drive.proton.me";
      default_launch_container = "window";
      custom_name = "Proton Drive";
    }
    {
      url = "https://mail.proton.me";
      default_launch_container = "window";
      custom_name = "Proton Mail";
    }
    {
      url = "https://web.whatsapp.com";
      default_launch_container = "window";
      custom_name = "WhatsApp";
    }
    {
      url = "https://youtube.com";
      default_launch_container = "window";
      custom_name = "YouTube";
    }
    {
      url = "https://app.zoom.us";
      default_launch_container = "window";
      custom_name = "Zoom";
    }
  ];
in {
  flake.meta.browser.pwaInstallForceList = pwaInstallForceList;

  flake.modules.nixos.browser-pwa = {pkgs, ...}: let
    browserPwaIconApply = pkgs.writeShellScriptBin "browser-pwa-icons-apply" ''
      #!/usr/bin/env bash
      set -euo pipefail

      apps_dir="''${HOME}/.local/share/applications"
      mkdir -p "$apps_dir"

      search_dirs=("$apps_dir")
      icon_search_roots=("$HOME/.local/share/icons" "$HOME/.local/share/pixmaps")
      if [[ -n "''${XDG_DATA_DIRS:-}" ]]; then
        IFS=':' read -r -a xdg_dirs <<< "''${XDG_DATA_DIRS}"
        for d in "''${xdg_dirs[@]}"; do
          if [[ -d "$d/applications" ]]; then
            search_dirs+=("$d/applications")
          fi
          if [[ -d "$d/icons" ]]; then
            icon_search_roots+=("$d/icons")
          fi
          if [[ -d "$d/pixmaps" ]]; then
            icon_search_roots+=("$d/pixmaps")
          fi
        done
      fi

      resolve_icon_path() {
        local icon_name="$1"
        local root
        local ext
        local match

        [[ -z "$icon_name" ]] && return 1

        if [[ "$icon_name" == /* && -e "$icon_name" ]]; then
          printf '%s\n' "$icon_name"
          return 0
        fi

        for root in "''${icon_search_roots[@]}"; do
          [[ -d "$root" ]] || continue
          for ext in png svg xpm; do
            match="$(find "$root" \( -type f -o -type l \) \( -path "*/$icon_name.$ext" -o -path "*/apps/$icon_name.$ext" \) -print -quit)"
            if [[ -n "$match" ]]; then
              printf '%s\n' "$match"
              return 0
            fi
          done
        done

        return 1
      }

      upsert_icon() {
        local desktop_file="$1"
        local icon_path="$2"

        if [[ ! -w "$desktop_file" ]]; then
          chmod u+w "$desktop_file" 2>/dev/null || true
        fi

        if [[ ! -w "$desktop_file" ]]; then
          printf 'warn: skipping unwritable desktop file: %s\n' "$desktop_file" >&2
          return 0
        fi

        if grep -q '^Icon=' "$desktop_file"; then
          sed -i "s|^Icon=.*$|Icon=$icon_path|" "$desktop_file"
        else
          printf '\nIcon=%s\n' "$icon_path" >> "$desktop_file"
        fi
      }

      update_icon() {
        local app_name="$1"
        local icon_path="$2"
        local resolved_icon_path

        resolved_icon_path="$(resolve_icon_path "$icon_path" || true)"
        if [[ -z "$resolved_icon_path" ]]; then
          printf 'warn: icon asset not found for %s (%s), leaving existing icon in place\n' "$app_name" "$icon_path" >&2
          return 0
        fi

        for d in "''${search_dirs[@]}"; do
          while IFS= read -r desktop_file; do
            local target="$desktop_file"
            if [[ ! -w "$desktop_file" ]]; then
              target="$apps_dir/$(basename "$desktop_file")"
              if [[ "$desktop_file" != "$target" ]]; then
                cp "$desktop_file" "$target"
              fi
              chmod u+w "$target" 2>/dev/null || true
            fi
            upsert_icon "$target" "$resolved_icon_path"
          done < <(grep -rl "^Name=$app_name$" "$d" || true)
        done
      }

      update_icon_by_desktop_id() {
        local desktop_id="$1"
        local icon_path="$2"
        local resolved_icon_path

        resolved_icon_path="$(resolve_icon_path "$icon_path" || true)"
        if [[ -z "$resolved_icon_path" ]]; then
          printf 'warn: icon asset not found for desktop id %s (%s), leaving existing icon in place\n' "$desktop_id" "$icon_path" >&2
          return 0
        fi

        for d in "''${search_dirs[@]}"; do
          if [[ -f "$d/$desktop_id" ]]; then
            local target="$d/$desktop_id"
            if [[ ! -w "$target" ]]; then
              target="$apps_dir/$desktop_id"
              if [[ "$d/$desktop_id" != "$target" ]]; then
                cp "$d/$desktop_id" "$target"
              fi
              chmod u+w "$target" 2>/dev/null || true
            fi
            upsert_icon "$target" "$resolved_icon_path"
          fi
        done
      }

      reset_brave_pwa_icons() {
        shopt -s nullglob
        for desktop_file in "$apps_dir"/brave-*-Default.desktop; do
          local icon_name
          icon_name="$(basename "$desktop_file" .desktop)"
          upsert_icon "$desktop_file" "$icon_name"
        done
        shopt -u nullglob
      }

      reset_brave_pwa_icons

      update_icon "Adobe Acrobat" "com.adobe.Reader"
      update_icon "Box" "box"
      update_icon "ChatGPT" "pwa-chatgpt"
      update_icon "Dropbox" "dropbox"
      update_icon "Excel" "ms-excel"
      update_icon "PowerPoint" "ms-powerpoint"
      update_icon "Microsoft Teams" "teams"
      update_icon "Word" "ms-word"
      update_icon "Outlook" "ms-outlook"
      update_icon "Proton Calendar" "pwa-proton-calendar"
      update_icon "Proton Drive" "pwa-proton-drive"
      update_icon "Proton Mail" "proton-mail"
      update_icon "WhatsApp" "whatsapp"
      update_icon "YouTube" "youtube"
      update_icon "Zoom" "Zoom"

      update_icon "Alacritty" "Alacritty"
      update_icon_by_desktop_id "Alacritty.desktop" "Alacritty"
      update_icon_by_desktop_id "alacritty.desktop" "Alacritty"

      update_icon "Ghostty" "com.mitchellh.ghostty"
      update_icon_by_desktop_id "com.mitchellh.ghostty.desktop" "com.mitchellh.ghostty"
      update_icon_by_desktop_id "ghostty.desktop" "com.mitchellh.ghostty"

      update_icon "kitty" "kitty"
      update_icon_by_desktop_id "kitty.desktop" "kitty"

      update_icon "Proton VPN" "proton-vpn-logo"
      update_icon_by_desktop_id "proton.vpn.app.gtk.desktop" "proton-vpn-logo"

      update_icon "Zed" "zed"
      update_icon "Zed Nightly" "zed"
      update_icon_by_desktop_id "dev.zed.Zed.desktop" "zed"
      update_icon_by_desktop_id "dev.zed.Zed-Nightly.desktop" "zed"

      update_icon "Neovim" "nvim"
      update_icon_by_desktop_id "nvim.desktop" "nvim"

      update_icon "Spotify" "spotify"
      update_icon_by_desktop_id "spotify.desktop" "spotify"

      update_icon "Virtual Machine Manager" "virt-manager"
      update_icon_by_desktop_id "virt-manager.desktop" "virt-manager"

      update_icon "btop++" "btop-custom"
      update_icon_by_desktop_id "btop.desktop" "btop-custom"

      printf 'Browser desktop icons updated.\n'
    '';
  in {
    environment.etc."brave/policies/managed/workstation-pwa.json".text = builtins.toJSON {
      WebAppInstallForceList = pwaInstallForceList;
    };

    environment.systemPackages = [browserPwaIconApply];

    system.activationScripts.pwaPostInstallInfo.text = ''
      echo "info: Browser PWA assets applied. After first browser run, execute: browser-pwa-icons-apply"
    '';
  };

  flake.modules.homeManager.browser-pwa-icons = {pkgs, ...}: let
    papirusAppIcons = "${pkgs.papirus-icon-theme}/share/icons/Papirus/48x48/apps";
  in {
    xdg.dataFile."icons/hicolor/scalable/apps/com.adobe.Reader.svg".source =
      ../../../assets/icons/acrobat.svg;
    xdg.dataFile."icons/hicolor/scalable/apps/box.svg".source = "${papirusAppIcons}/box.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/dropbox.svg".source = "${papirusAppIcons}/dropbox.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/ms-excel.svg".source = "${papirusAppIcons}/ms-excel.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/ms-powerpoint.svg".source = "${papirusAppIcons}/ms-powerpoint.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/teams.svg".source = "${papirusAppIcons}/teams.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/ms-word.svg".source = "${papirusAppIcons}/ms-word.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/ms-outlook.svg".source = "${papirusAppIcons}/ms-outlook.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/proton-mail.svg".source = "${papirusAppIcons}/proton-mail.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/whatsapp.svg".source = "${papirusAppIcons}/whatsapp.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/youtube.svg".source = "${papirusAppIcons}/youtube.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/Zoom.svg".source = "${papirusAppIcons}/Zoom.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/Alacritty.svg".source = "${papirusAppIcons}/Alacritty.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/com.mitchellh.ghostty.svg".source = "${papirusAppIcons}/com.mitchellh.ghostty.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/kitty.svg".source = "${papirusAppIcons}/kitty.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/proton-vpn-logo.svg".source = "${papirusAppIcons}/proton-vpn-logo.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/zed.svg".source = "${papirusAppIcons}/zed.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/nvim.svg".source = "${papirusAppIcons}/nvim.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/spotify.svg".source = "${papirusAppIcons}/spotify.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/virt-manager.svg".source = "${papirusAppIcons}/virt-manager.svg";
    xdg.dataFile."icons/hicolor/scalable/apps/btop.svg".source =
      ../../../assets/icons/btop.svg;
    xdg.dataFile."icons/hicolor/scalable/apps/btop-custom.svg".source =
      ../../../assets/icons/btop.svg;
    xdg.dataFile."icons/hicolor/48x48/apps/btop-custom.svg".source =
      ../../../assets/icons/btop.svg;

    xdg.dataFile."icons/hicolor/scalable/apps/pwa-chatgpt.svg".source =
      ../../../assets/icons/chatgpt.svg;
    xdg.dataFile."icons/hicolor/48x48/apps/pwa-chatgpt.svg".source =
      ../../../assets/icons/chatgpt.svg;
    xdg.dataFile."icons/hicolor/scalable/apps/pwa-proton-calendar.svg".source =
      ../../../assets/icons/proton-calendar.svg;
    xdg.dataFile."icons/hicolor/48x48/apps/pwa-proton-calendar.svg".source =
      ../../../assets/icons/proton-calendar.svg;
    xdg.dataFile."icons/hicolor/scalable/apps/pwa-proton-drive.svg".source =
      ../../../assets/icons/proton-drive.svg;
    xdg.dataFile."icons/hicolor/48x48/apps/pwa-proton-drive.svg".source =
      ../../../assets/icons/proton-drive.svg;
  };
}
