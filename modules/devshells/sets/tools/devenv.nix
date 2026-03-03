_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.devenv = with config._module.args.pkgs; [
        devenv
      ];
    };
}
