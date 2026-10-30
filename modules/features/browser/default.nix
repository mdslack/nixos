{ config, ... }:
{
  flake.modules.nixos.browser = {
    imports = [
      config.flake.modules.nixos.browser-pwa
      config.flake.modules.nixos.browser-brave
      config.flake.modules.nixos.browser-terminal
    ];
  };

  flake.modules.homeManager.browser = {
    imports = [
      config.flake.modules.homeManager.browser-brave
      config.flake.modules.homeManager.browser-mime
      config.flake.modules.homeManager.browser-pwa-icons
    ];
  };
}
