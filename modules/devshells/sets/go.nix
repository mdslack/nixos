_: {
  perSystem =
    {
      config,
      pkgsUnstable,
      ...
    }:
    {
      dev.shellSets.go = with config._module.args.pkgs; [
        go
        pkgsUnstable.hugo
        gopls
        golangci-lint
        delve
        gotools
      ];
    };
}
