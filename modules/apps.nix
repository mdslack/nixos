{ lib, config, pkgs, ... }:
let
  cfg = config.workstation.apps;
  alacrittyIconPath = ../assets/pwa-icons/alacritty.png;
  zedIconPath = ../assets/pwa-icons/zed.png;

  bravePwaIconApply = pkgs.writeShellScriptBin "brave-pwa-icons-apply" ''
    #!/usr/bin/env bash
    set -euo pipefail

    apps_dir="''${HOME}/.local/share/applications"
    if [[ ! -d "$apps_dir" ]]; then
      printf 'No applications directory found at %s\n' "$apps_dir" >&2
      exit 0
    fi

    update_icon() {
      local app_name="$1"
      local icon_path="$2"
      while IFS= read -r desktop_file; do
        if grep -q '^Icon=' "$desktop_file"; then
          sed -i "s|^Icon=.*$|Icon=$icon_path|" "$desktop_file"
        else
          printf '\nIcon=%s\n' "$icon_path" >> "$desktop_file"
        fi
      done < <(grep -rl "^Name=$app_name$" "$apps_dir" || true)
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

    # Optional custom app icons. Provide files to enable these overrides.
    if [[ -f /etc/pwa-icons/alacritty.png ]]; then
      update_icon "Alacritty" "/etc/pwa-icons/alacritty.png"
    fi
    if [[ -f /etc/pwa-icons/zed.png ]]; then
      update_icon "Zed" "/etc/pwa-icons/zed.png"
    fi

    printf 'Brave PWA desktop icons updated.\n'
  '';
in {
  options.workstation.apps = {
    enable = lib.mkEnableOption "workstation app profile";

    enableBravePwas = lib.mkEnableOption "Brave forced web app installs";

    bravePwaInstallList = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.str);
      default = [
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
      description = "Brave WebAppInstallForceList entries.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.enableBravePwas {
      environment.etc."brave/policies/managed/workstation.json".text = builtins.toJSON {
        WebAppInstallForceList = cfg.bravePwaInstallList;
      };

      environment.etc."pwa-icons/acrobat.png".source = ../assets/pwa-icons/acrobat.png;
      environment.etc."pwa-icons/box.png".source = ../assets/pwa-icons/box.png;
      environment.etc."pwa-icons/chatgpt.png".source = ../assets/pwa-icons/chatgpt.png;
      environment.etc."pwa-icons/dropbox.png".source = ../assets/pwa-icons/dropbox.png;
      environment.etc."pwa-icons/excel.png".source = ../assets/pwa-icons/excel.png;
      environment.etc."pwa-icons/powerpoint.png".source = ../assets/pwa-icons/powerpoint.png;
      environment.etc."pwa-icons/teams.png".source = ../assets/pwa-icons/teams.png;
      environment.etc."pwa-icons/word.png".source = ../assets/pwa-icons/word.png;
      environment.etc."pwa-icons/outlook.png".source = ../assets/pwa-icons/outlook.png;
      environment.etc."pwa-icons/proton-calendar.png".source = ../assets/pwa-icons/proton-calendar.png;
      environment.etc."pwa-icons/proton-drive.png".source = ../assets/pwa-icons/proton-drive.png;
      environment.etc."pwa-icons/proton-mail.png".source = ../assets/pwa-icons/proton-mail.png;
      environment.etc."pwa-icons/whatsapp.png".source = ../assets/pwa-icons/whatsapp.png;
      environment.etc."pwa-icons/youtube.png".source = ../assets/pwa-icons/youtube.png;
      environment.etc."pwa-icons/zoom.png".source = ../assets/pwa-icons/zoom.png;
      environment.etc = lib.optionalAttrs (builtins.pathExists alacrittyIconPath) {
        "pwa-icons/alacritty.png".source = alacrittyIconPath;
      } // lib.optionalAttrs (builtins.pathExists zedIconPath) {
        "pwa-icons/zed.png".source = zedIconPath;
      };

      environment.systemPackages = [ bravePwaIconApply ];

      warnings = [
        "Brave PWA policy is managed at /etc/brave/policies/managed/workstation.json. Restart Brave to apply changes."
        "Run brave-pwa-icons-apply after Brave creates PWA desktop files to set custom icons."
      ];
    })
  ]);
}
