{ config, ... }:
{
  flake.modules.nixos.browser = {
    imports = [
      config.flake.modules.nixos.browser-pwa
      config.flake.modules.nixos.browser-brave
    ];
  };

  flake.modules.homeManager.browser = {
    imports = [
      config.flake.modules.homeManager.browser-brave
      config.flake.modules.homeManager.browser-pwa-icons
    ];
  };
}
