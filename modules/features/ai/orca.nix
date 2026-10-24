_:
let
  mkOrca = pkgs: pkgs.callPackage ../../../packages/orca-ide.nix { };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.orca-ide = mkOrca pkgs;
    };

  flake.modules.nixos.ai-orca =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (mkOrca pkgs) ];
    };
}
