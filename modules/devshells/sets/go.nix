_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.go = with config._module.args.pkgs; [
        go
        hugo
        gopls
        golangci-lint
        delve
        gotools
      ];
    };
}
