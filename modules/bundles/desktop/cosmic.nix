{config, ...}: {
  flake.modules.nixos.bundle-desktop-cosmic = {
    imports = [
      config.flake.modules.nixos.desktop-minimal
      config.flake.modules.nixos.desktop-cosmic
    ];
  };
}
