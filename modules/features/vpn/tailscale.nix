{...}: {
  flake.modules.nixos.vpn-tailscale = {
    services.tailscale = {
      enable = true;
      extraSetFlags = ["--ssh"];
    };
  };
}
