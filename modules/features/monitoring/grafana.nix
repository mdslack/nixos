_: {
  flake.modules.nixos.monitoring-grafana = {
    services.grafana = {
      enable = true;

      settings.server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "localhost";
      };

      provision = {
        enable = true;
        datasources.settings = {
          apiVersion = 1;
          datasources = [
            {
              name = "VictoriaMetrics";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:8428";
              isDefault = true;
            }
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:9090";
            }
          ];
        };
      };
    };
  };
}
