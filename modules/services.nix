{ lib, config, username, ... }:
let
  cfg = config.workstation.services;
in {
  options.workstation.services = {
    enable = lib.mkEnableOption "workstation service profile";

    enableTailscale = lib.mkEnableOption "Tailscale service";

    enableExpressVpnManualReminder = lib.mkEnableOption "manual ExpressVPN GUI install reminder";

    expressvpnManualInstallPath = lib.mkOption {
      type = lib.types.str;
      default = "/home/${username}/Downloads/expressvpn-installer.run";
      description = "Expected path for manual ExpressVPN GUI installer.";
    };

  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.enableTailscale {
      services.tailscale.enable = true;
    })

    (lib.mkIf cfg.enableExpressVpnManualReminder {
      warnings = [
        "ExpressVPN is set to manual GUI install. Place installer at ${cfg.expressvpnManualInstallPath} and run it from a graphical session."
      ];
    })
  ]);
}
