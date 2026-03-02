{config, ...}: {
  flake.modules.nixos.files = {
    imports = [
      config.flake.modules.nixos.files-yazi
    ];
  };

  flake.modules.homeManager.files = {
    imports = [
      config.flake.modules.homeManager.files-yazi
    ];
  };
}
