_:
let
  mkTerminalBrowser = pkgs: pkgs.callPackage ../../../packages/terminal-browser.nix { };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.terminal-browser = mkTerminalBrowser pkgs;
    };

  flake.modules.nixos.browser-terminal =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (mkTerminalBrowser pkgs) ];
    };
}
