_: {
  flake.modules.nixos.monitoring-prometheus = {
    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9090;

      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [
            {
              targets = [ "127.0.0.1:9090" ];
            }
          ];
        }
        {
          job_name = "victoriametrics";
          metrics_path = "/metrics";
          static_configs = [
            {
              targets = [ "127.0.0.1:8428" ];
            }
          ];
        }
      ];
    };
  };
}
