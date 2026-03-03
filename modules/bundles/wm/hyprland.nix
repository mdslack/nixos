{ config, ... }:
{
  flake.modules.nixos.bundle-wm-hyprland = {
    imports = [
      config.flake.modules.nixos.desktop-minimal
      config.flake.modules.nixos.wm-hyprland
    ];
  };
}
