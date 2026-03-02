{config, ...}: {
  flake.modules.nixos.desktop-cosmic = {
    imports = [
      config.flake.modules.nixos.desktop-minimal
      config.flake.modules.nixos.desktop-cosmic
    ];
  };
}
