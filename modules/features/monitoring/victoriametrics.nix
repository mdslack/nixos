_: {
  flake.modules.nixos.monitoring-victoriametrics = {
    services.victoriametrics = {
      enable = true;
      listenAddress = "127.0.0.1:8428";
      retentionPeriod = "30d";

      prometheusConfig.scrape_configs = [
        {
          job_name = "victoriametrics";
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
