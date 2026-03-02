{config, ...}: {
  flake.modules.nixos.features.graphics.egpu = {
    imports = [
      config.flake.modules.nixos.features.graphics.nvidia
    ];

    services.hardware.bolt.enable = true;
  };
}
