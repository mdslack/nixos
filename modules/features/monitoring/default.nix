{ config, ... }:
{
  flake.modules.nixos.monitoring = {
    imports = [
      config.flake.modules.nixos.monitoring-victoriametrics
    ];
  };
}
