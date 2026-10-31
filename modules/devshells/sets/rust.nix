_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.rust = with config._module.args.pkgs; [
        (rust-bin.stable.latest.default.override {
          targets = [ "wasm32-unknown-unknown" ];
        })
        wasm-pack
        wasm-bindgen-cli
        rust-analyzer
        cargo-nextest
        pkg-config
        wayland
        wayland-scanner
        wayland-protocols
      ];
    };
}
