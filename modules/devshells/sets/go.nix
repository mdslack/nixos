{...}: {
  perSystem = {
    config,
    ...
  }: {
    dev.shellSets.go = with config._module.args.pkgs; [
      go
      gopls
      golangci-lint
      delve
      gotools
    ];
  };
}
