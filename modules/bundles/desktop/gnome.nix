{config, ...}: {
  flake.modules.nixos.desktop.gnome = {
    imports = [
      config.flake.modules.nixos.desktop.minimal
      config.flake.modules.nixos.features.desktop.gnome
    ];
  };
}
