{config, ...}: {
  flake.modules.nixos.vpn = {
    imports = [
      config.flake.modules.nixos.vpn-tailscale
      config.flake.modules.nixos.vpn-proton
    ];
  };
}
