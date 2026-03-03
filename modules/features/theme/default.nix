{ config, ... }:
{
  flake.modules.nixos.theme = {
    imports = [
      config.flake.modules.nixos.theme-matugen
    ];
  };
}
