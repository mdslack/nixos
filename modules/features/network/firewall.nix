{...}: {
  flake.modules.nixos.features.network.firewall = {
    networking.firewall.enable = true;
  };
}
