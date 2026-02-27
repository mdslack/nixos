{ lib, pkgs, ... }:
{
  config = lib.mkMerge [
    {
      services.tailscale.enable = true;
    }

    {
      environment.systemPackages = [ pkgs.protonvpn-gui ];
    }

    {
      environment.systemPackages = lib.optionals (builtins.hasAttr "proton-vpn-cli" pkgs) [ pkgs."proton-vpn-cli" ];
    }
  ];
}
