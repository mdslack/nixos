_: {
  flake.modules.nixos.communication-zoom =
    { pkgsUnstable, ... }:
    {
      environment.systemPackages = [
        pkgsUnstable.zoom-us
      ];
    };
}
