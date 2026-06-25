_: {
  flake.modules.nixos.terminal-herdr =
    { inputs, pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
