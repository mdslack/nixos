{ config, ... }:
{
  flake.modules.nixos.desktop-minimal = {
    imports = [
      config.flake.modules.nixos.theme
      config.flake.modules.nixos.browser
      config.flake.modules.nixos.cloud
      config.flake.modules.nixos.editor
      config.flake.modules.nixos.input
      config.flake.modules.nixos.media
    ];
  };
}
