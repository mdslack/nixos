{ config, ... }:
{
  flake.modules.nixos.network = {
    imports = [
      config.flake.modules.nixos.network-firewall
      config.flake.modules.nixos.network-ssh
    ];

    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "wpa_supplicant";
  };
}
