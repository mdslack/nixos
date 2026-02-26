{ lib, config, pkgs, username, ... }:
let
  cfg = config.workstation.services;
in {
  options.workstation.services = {
    enable = lib.mkEnableOption "workstation service profile";

    enableTailscale = lib.mkEnableOption "Tailscale service";

    enableProtonVpn = lib.mkEnableOption "Proton VPN GUI package";

    enableExpressVpnManualReminder = lib.mkEnableOption "manual ExpressVPN GUI install reminder";

    enableExpressVpnManualService = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Manage expressvpn-service via NixOS for manually installed GUI client.";
    };

    enableExpressVpnRuntimeCompat = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable nix-ld and common runtime deps for the ExpressVPN GUI installer and binaries.";
    };

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

    (lib.mkIf cfg.enableProtonVpn {
      environment.systemPackages = [ pkgs.protonvpn-gui ];
      warnings = [
        "Proton VPN GUI installed. Launch with: protonvpn-app"
      ];
    })

    (lib.mkIf cfg.enableExpressVpnManualReminder {
      warnings = [
        "ExpressVPN is set to manual GUI install. Place installer at ${cfg.expressvpnManualInstallPath} and run it from a graphical session."
      ];
    })

    (lib.mkIf cfg.enableExpressVpnRuntimeCompat {
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc.lib
        glib
        brotli
        fontconfig
        freetype
        dbus
        libxau
        libxdmcp
        libxcb
        xcbutil
        pkgs."xcb-util-cursor"
        libSM
        libICE
        libnl
        libxkbcommon
        libglvnd
        openssl
        zlib
      ];

      environment.systemPackages = with pkgs; [
        libcap
        iproute2
        iptables
        procps
        psmisc
        xterm
        cacert
      ];

      # ExpressVPN still checks legacy FHS command paths.
      systemd.tmpfiles.rules = [
        "L+ /bin/iptables - - - - ${pkgs.iptables}/bin/iptables"
        "L+ /usr/bin/iptables - - - - ${pkgs.iptables}/bin/iptables"
        "L+ /sbin/iptables - - - - ${pkgs.iptables}/bin/iptables"
        "L+ /usr/sbin/iptables - - - - ${pkgs.iptables}/bin/iptables"
        "L+ /bin/ip6tables - - - - ${pkgs.iptables}/bin/ip6tables"
        "L+ /usr/bin/ip6tables - - - - ${pkgs.iptables}/bin/ip6tables"
        "L+ /sbin/ip6tables - - - - ${pkgs.iptables}/bin/ip6tables"
        "L+ /usr/sbin/ip6tables - - - - ${pkgs.iptables}/bin/ip6tables"
        "L+ /bin/iptables-nft - - - - ${pkgs.iptables}/bin/iptables-nft"
        "L+ /usr/bin/iptables-nft - - - - ${pkgs.iptables}/bin/iptables-nft"
        "L+ /sbin/iptables-nft - - - - ${pkgs.iptables}/bin/iptables-nft"
        "L+ /usr/sbin/iptables-nft - - - - ${pkgs.iptables}/bin/iptables-nft"
      ];
    })

    (lib.mkIf cfg.enableExpressVpnManualService {
      systemd.services.expressvpn-service = {
        description = "ExpressVPN daemon";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Environment = [ "LD_LIBRARY_PATH=/opt/expressvpn/lib" ];
          ExecStart = "/opt/expressvpn/bin/expressvpn-daemon";
          Restart = "always";
        };
      };
    })
  ]);
}
