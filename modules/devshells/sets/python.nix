_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.python = with config._module.args.pkgs; [
        python3
        uv
        ruff
        basedpyright
      ];
    };
}
