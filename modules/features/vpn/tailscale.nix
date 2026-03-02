{...}: {
  flake.modules.nixos.features.vpn.tailscale = {
    services.tailscale.enable = true;
  };
}
