{pkgs, ...}: let
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

  browserPwaIconApply = pkgs.writeShellScriptBin "browser-pwa-icons-apply" ''
    #!/usr/bin/env bash
    set -euo pipefail

    apps_dir="''${HOME}/.local/share/applications"
    mkdir -p "$apps_dir"

    search_dirs=("$apps_dir")
    if [[ -n "''${XDG_DATA_DIRS:-}" ]]; then
      IFS=':' read -r -a xdg_dirs <<< "''${XDG_DATA_DIRS}"
      for d in "''${xdg_dirs[@]}"; do
        if [[ -d "$d/applications" ]]; then
          search_dirs+=("$d/applications")
        fi
      done
    fi

    upsert_icon() {
      local desktop_file="$1"
      local icon_path="$2"
      if grep -q '^Icon=' "$desktop_file"; then
        sed -i "s|^Icon=.*$|Icon=$icon_path|" "$desktop_file"
      else
        printf '\nIcon=%s\n' "$icon_path" >> "$desktop_file"
      fi
    }

    update_icon() {
      local app_name="$1"
      local icon_path="$2"
      for d in "''${search_dirs[@]}"; do
        while IFS= read -r desktop_file; do
          local target="$desktop_file"
          if [[ ! -w "$desktop_file" ]]; then
            target="$apps_dir/$(basename "$desktop_file")"
            cp "$desktop_file" "$target"
          fi
          upsert_icon "$target" "$icon_path"
        done < <(grep -rl "^Name=$app_name$" "$d" || true)
      done
    }

    update_icon "Adobe Acrobat" "/etc/pwa-icons/acrobat.png"
    update_icon "Box" "/etc/pwa-icons/box.png"
    update_icon "ChatGPT" "/etc/pwa-icons/chatgpt.png"
    update_icon "Dropbox" "/etc/pwa-icons/dropbox.png"
    update_icon "Excel" "/etc/pwa-icons/excel.png"
    update_icon "PowerPoint" "/etc/pwa-icons/powerpoint.png"
    update_icon "Microsoft Teams" "/etc/pwa-icons/teams.png"
    update_icon "Word" "/etc/pwa-icons/word.png"
    update_icon "Outlook" "/etc/pwa-icons/outlook.png"
    update_icon "Proton Calendar" "/etc/pwa-icons/proton-calendar.png"
    update_icon "Proton Drive" "/etc/pwa-icons/proton-drive.png"
    update_icon "Proton Mail" "/etc/pwa-icons/proton-mail.png"
    update_icon "WhatsApp" "/etc/pwa-icons/whatsapp.png"
    update_icon "YouTube" "/etc/pwa-icons/youtube.png"
    update_icon "Zoom" "/etc/pwa-icons/zoom.png"

    printf 'Browser PWA desktop icons updated.\n'
  '';
in {
  flake.modules.nixos.features.browser.pwa = {
    flake.meta.browser.pwaInstallForceList = pwaInstallForceList;

    environment.etc."pwa-icons/acrobat.png".source = ../../../assets/pwa-icons/acrobat.png;
    environment.etc."pwa-icons/box.png".source = ../../../assets/pwa-icons/box.png;
    environment.etc."pwa-icons/chatgpt.png".source = ../../../assets/pwa-icons/chatgpt.png;
    environment.etc."pwa-icons/dropbox.png".source = ../../../assets/pwa-icons/dropbox.png;
    environment.etc."pwa-icons/excel.png".source = ../../../assets/pwa-icons/excel.png;
    environment.etc."pwa-icons/powerpoint.png".source = ../../../assets/pwa-icons/powerpoint.png;
    environment.etc."pwa-icons/teams.png".source = ../../../assets/pwa-icons/teams.png;
    environment.etc."pwa-icons/word.png".source = ../../../assets/pwa-icons/word.png;
    environment.etc."pwa-icons/outlook.png".source = ../../../assets/pwa-icons/outlook.png;
    environment.etc."pwa-icons/proton-calendar.png".source = ../../../assets/pwa-icons/proton-calendar.png;
    environment.etc."pwa-icons/proton-drive.png".source = ../../../assets/pwa-icons/proton-drive.png;
    environment.etc."pwa-icons/proton-mail.png".source = ../../../assets/pwa-icons/proton-mail.png;
    environment.etc."pwa-icons/whatsapp.png".source = ../../../assets/pwa-icons/whatsapp.png;
    environment.etc."pwa-icons/youtube.png".source = ../../../assets/pwa-icons/youtube.png;
    environment.etc."pwa-icons/zoom.png".source = ../../../assets/pwa-icons/zoom.png;

    environment.systemPackages = [browserPwaIconApply];

    system.activationScripts.pwaPostInstallInfo.text = ''
      echo "info: Browser PWA assets applied. After first browser run, execute: browser-pwa-icons-apply"
    '';
  };
}
