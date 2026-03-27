{ config, ... }:
{
  flake.modules.nixos.communication = {
    imports = [
      config.flake.modules.nixos.communication-zoom
    ];
  };
}
