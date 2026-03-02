{config, ...}: {
  flake.modules.nixos.features.browser = {
    imports = [
      config.flake.modules.nixos.features.browser.pwa
      config.flake.modules.nixos.features.browser.brave
    ];
  };

  flake.modules.homeManager.features.browser = {
    imports = [
      config.flake.modules.homeManager.features.browser.brave
    ];
  };
}
