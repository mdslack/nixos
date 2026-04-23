{ config, ... }:
{
  flake.modules.nixos.monitoring = {
    imports = [
      config.flake.modules.nixos.monitoring-grafana
      config.flake.modules.nixos.monitoring-prometheus
      config.flake.modules.nixos.monitoring-victoriametrics
    ];
  };
}
