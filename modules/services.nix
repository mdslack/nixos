{ lib, config, pkgs, ... }:
let
  cfg = config.workstation.services;
in {
  options.workstation.services = {
    enable = lib.mkEnableOption "workstation service profile";

    enableTailscale = lib.mkEnableOption "Tailscale service";

    enableExpressVpnPackage = lib.mkEnableOption "ExpressVPN package from nixpkgs";

    enableExpressVpnService = lib.mkEnableOption "systemd expressvpnd service";

  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.enableTailscale {
      services.tailscale.enable = true;
    })

    (lib.mkIf cfg.enableExpressVpnPackage {
      environment.systemPackages = [ pkgs.expressvpn ];
      warnings = [
        "ExpressVPN package is installed. Verify behavior with: expressvpn --version, expressvpn status, then activate/login if required."
      ];
    })

    (lib.mkIf (cfg.enableExpressVpnPackage && cfg.enableExpressVpnService) {
      systemd.services.expressvpnd = {
        description = "ExpressVPN daemon";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.expressvpn}/bin/expressvpnd";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    })
  ]);
}
