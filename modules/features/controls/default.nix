{ config, ... }:
{
  flake.modules.nixos.controls = {
    imports = [
      config.flake.modules.nixos.controls-keylightd
      config.flake.modules.nixos.controls-packages
    ];
  };
}
