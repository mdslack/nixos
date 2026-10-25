_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.rust = with config._module.args.pkgs; [
        rust-bin.stable.latest.default
        rust-analyzer
        cargo-nextest
        pkg-config
        wayland
        wayland-scanner
        wayland-protocols
      ];
    };
}
