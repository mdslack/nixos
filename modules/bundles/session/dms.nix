{config, ...}: {
  flake.modules.nixos.session.dms = {
    imports = [
      config.flake.modules.nixos.features.session.dms
    ];

    home-manager.sharedModules = [
      config.flake.modules.homeManager.features.session.dms
    ];
  };
}
