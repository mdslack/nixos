{config, ...}: {
  flake.modules.nixos.features.theme = {
    imports = [
      config.flake.modules.nixos.features.theme.matugen
      config.flake.modules.nixos.features.theme.stylix
    ];
  };
}
