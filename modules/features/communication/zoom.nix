_: {
  flake.modules.nixos.communication-zoom =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.zoom-us
      ];
    };
}
