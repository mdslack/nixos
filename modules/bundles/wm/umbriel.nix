{ config, ... }:
{
  flake.modules.nixos.bundle-wm-umbriel = {
    imports = [
      config.flake.modules.nixos.desktop-minimal
      config.flake.modules.nixos.wm-umbriel
    ];
    home-manager.sharedModules = [ config.flake.modules.homeManager.wm-umbriel ];
  };
}
