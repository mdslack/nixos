{...}: {
  perSystem = {
    config,
    ...
  }: {
    dev.shellSets.node = with config._module.args.pkgs; [
      nodejs
    ];
  };
}
