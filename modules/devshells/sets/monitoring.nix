_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.monitoring = with config._module.args.pkgs; [
        victoriametrics
      ];
    };
}
