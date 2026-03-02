{config, ...}: {
  flake.modules.nixos.desktop.minimal = {
    imports = [
      config.flake.modules.nixos.features.browser
      config.flake.modules.nixos.features.cloud.maestral
      config.flake.modules.nixos.features.editor
      config.flake.modules.nixos.features.input
      config.flake.modules.nixos.features.media
    ];
  };
}
