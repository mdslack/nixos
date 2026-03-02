{config, ...}: {
  flake.modules.nixos.session.noctalia = {
    imports = [
      config.flake.modules.nixos.features.session.noctalia
    ];

    home-manager.sharedModules = [
      config.flake.modules.homeManager.features.session.noctalia
    ];
  };
}
