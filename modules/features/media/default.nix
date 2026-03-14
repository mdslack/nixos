{config, ...}: {
  flake.modules.nixos.media = {
    imports = [
      config.flake.modules.nixos.media-recording
      config.flake.modules.nixos.media-spotify
    ];
  };
}
