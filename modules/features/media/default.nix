{config, ...}: {
  flake.modules.nixos.features.media = {
    imports = [
      config.flake.modules.nixos.features.media.spotify
    ];
  };
}
