{config, ...}: {
  flake.modules.nixos.media = {
    imports = [
      config.flake.modules.nixos.media-spotify
    ];
  };
}
