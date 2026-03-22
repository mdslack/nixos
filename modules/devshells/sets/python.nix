_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.python = with config._module.args.pkgs; [
        python3
        python3.pkgs.tkinter
        uv
        ruff
        basedpyright
      ];
    };
}
