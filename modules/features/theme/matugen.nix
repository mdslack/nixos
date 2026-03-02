{pkgs, ...}: {
  flake.modules.nixos.features.theme.matugen = {
    environment.systemPackages = [
      pkgs.matugen
    ];
  };
}
