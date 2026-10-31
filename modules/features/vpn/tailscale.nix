_: {
  flake.modules.nixos.vpn-tailscale = {
    services.tailscale = {
      enable = true;
      # Use OpenSSH over the tailnet so Moshi key auth and Mosh work.
      extraSetFlags = [ "--ssh=false" ];
    };
  };
}
