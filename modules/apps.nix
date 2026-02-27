{ lib, config, ... }:
let
  cfg = config.workstation.apps;
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

      warnings = [
        "Brave PWA policy is managed at /etc/brave/policies/managed/workstation.json. Restart Brave to apply changes."
      ];
    })
  ]);
}
