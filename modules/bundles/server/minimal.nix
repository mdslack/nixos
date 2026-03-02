{config, ...}: {
  flake.modules.nixos.server.minimal = {
    imports = [
      config.flake.modules.nixos.minimal
    ];
  };
}
