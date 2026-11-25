{ inputs, ... }:
{
  flake.modules.nixos.communication-zoom =
    { pkgs, ... }:
    let
      zoomPkgs = import inputs.nixpkgs-app-updates {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    in
    {
      environment.systemPackages = [
        zoomPkgs.zoom-us
      ];
    };
}
