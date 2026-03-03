{ config, ... }:
{
  flake.modules.nixos.bundle-desktop-kde = {
    imports = [
      config.flake.modules.nixos.desktop-minimal
      config.flake.modules.nixos.desktop-kde
    ];
  };
}
