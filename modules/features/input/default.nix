{ config, ... }:
{
  flake.modules.nixos.input = {
    imports = [
      config.flake.modules.nixos.input-fcitx5
      config.flake.modules.nixos.input-pipewire
    ];
  };
}
