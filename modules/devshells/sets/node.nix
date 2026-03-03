_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.node = with config._module.args.pkgs; [
        nodejs
        nodePackages.eslint
      ];
    };
}
