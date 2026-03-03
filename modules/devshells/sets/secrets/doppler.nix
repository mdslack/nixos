_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.doppler = with config._module.args.pkgs; [
        doppler
      ];
    };
}
