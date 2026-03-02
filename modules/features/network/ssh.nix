{...}: {
  flake.modules.nixos.features.network.ssh = {
    services.openssh.enable = true;
  };
}
