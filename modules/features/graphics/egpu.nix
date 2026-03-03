{ config, ... }:
{
  flake.modules.nixos.graphics-egpu = {
    imports = [
      config.flake.modules.nixos.graphics-nvidia
    ];

    services.hardware.bolt.enable = true;
  };
}
