{config, ...}: {
  flake.modules.nixos.session-noctalia = {
    imports = [
      config.flake.modules.nixos.session-noctalia
    ];

    home-manager.sharedModules = [
      config.flake.modules.homeManager.session-noctalia
    ];
  };
}
