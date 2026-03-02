{config, ...}: {
  flake.modules.nixos.bundle-wm-niri = {
    imports = [
      config.flake.modules.nixos.desktop-minimal
      config.flake.modules.nixos.wm-niri
    ];

    home-manager.sharedModules = [
      config.flake.modules.homeManager.wm-niri
    ];
  };
}
