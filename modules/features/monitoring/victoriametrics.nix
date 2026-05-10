_: {
  flake.modules.nixos.monitoring-victoriametrics = {
    services.victoriametrics = {
      enable = true;
      listenAddress = "0.0.0.0:8428";
      retentionPeriod = "1y";
    };
  };
}
