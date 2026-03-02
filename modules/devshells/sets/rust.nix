{...}: {
  perSystem = {
    config,
    ...
  }: {
    dev.shellSets.rust = with config._module.args.pkgs; [
      rust-bin.stable.latest.default
      rust-analyzer
    ];
  };
}
