{config, ...}: {
  flake.modules.nixos.features.input = {
    imports = [
      config.flake.modules.nixos.features.input.fcitx5
      config.flake.modules.nixos.features.input.pipewire
    ];
  };
}
