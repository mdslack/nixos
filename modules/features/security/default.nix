{ config, ... }:
{
  flake.modules.nixos.security = {
    imports = [
      config.flake.modules.nixos.security-yubikey
    ];
  };
}
