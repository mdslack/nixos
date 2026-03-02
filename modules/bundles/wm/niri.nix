{config, ...}: {
  flake.modules.nixos.wm.niri = {
    imports = [
      config.flake.modules.nixos.desktop.minimal
      config.flake.modules.nixos.features.wm.niri
    ];

    home-manager.sharedModules = [
      config.flake.modules.homeManager.features.wm.niri
    ];
  };
}
