_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.protobuf = with config._module.args.pkgs; [
        protobuf
      ];
    };
}
