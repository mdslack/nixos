{...}: {
  flake.modules.nixos.network-firewall = {
    networking.firewall.enable = true;
  };
}
