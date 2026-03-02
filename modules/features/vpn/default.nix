{config, ...}: {
  flake.modules.nixos.features.vpn = {
    imports = [
      config.flake.modules.nixos.features.vpn.tailscale
      config.flake.modules.nixos.features.vpn.proton
    ];
  };
}
