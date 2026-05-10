_: {
  flake.modules.nixos.monitoring-prometheus = {
    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9090;
      extraFlags = [ "--web.enable-admin-api" ];
      remoteWrite = [
        {
          url = "http://127.0.0.1:8428/api/v1/write";
          write_relabel_configs = [
            {
              target_label = "source";
              replacement = "framework13-local-prometheus";
              action = "replace";
            }
            {
              source_labels = [ "__name__" ];
              regex = "up";
              action = "keep";
            }
          ];
          queue_config = {
            capacity = 10000;
            min_shards = 1;
            max_shards = 4;
            max_samples_per_send = 2000;
            batch_send_deadline = "5s";
            min_backoff = "1s";
            max_backoff = "30s";
          };
        }
      ];

      scrapeConfigs = [
        {
          job_name = "prometheus";
          metric_relabel_configs = [
            {
              source_labels = [ "__name__" ];
              regex = ".+";
              action = "drop";
            }
          ];
          static_configs = [
            {
              targets = [ "127.0.0.1:9090" ];
            }
          ];
        }
        {
          job_name = "victoriametrics";
          metrics_path = "/metrics";
          metric_relabel_configs = [
            {
              source_labels = [ "__name__" ];
              regex = ".+";
              action = "drop";
            }
          ];
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
