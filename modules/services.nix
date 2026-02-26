{ lib, config, pkgs, ... }:
let
  cfg = config.workstation.services;
in {
  options.workstation.services = {
    enable = lib.mkEnableOption "workstation service profile";

    enableTailscale = lib.mkEnableOption "Tailscale service";

    enableProtonVpn = lib.mkEnableOption "Proton VPN GUI package";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.enableTailscale {
      services.tailscale.enable = true;
    })

    (lib.mkIf cfg.enableProtonVpn {
      environment.systemPackages = [ pkgs.protonvpn-gui ];
      warnings = [
        "Proton VPN GUI installed. Launch with: protonvpn-app"
      ];
    })
  ]);
}
