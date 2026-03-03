{ config, ... }:
{
  flake.modules.nixos.bundle-session-dms = {
    imports = [
      config.flake.modules.nixos.session-dms
    ];

    home-manager.sharedModules = [
      config.flake.modules.homeManager.session-dms
    ];
  };
}
