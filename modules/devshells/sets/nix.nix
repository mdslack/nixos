_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.nix = with config._module.args.pkgs; [
        nil
        nixfmt
        deadnix
        statix
      ];
    };
}
