{ config, ... }:
{
  flake.modules.nixos.bundle-desktop-gnome = {
    imports = [
      config.flake.modules.nixos.desktop-minimal
      config.flake.modules.nixos.desktop-gnome
    ];
  };
}
