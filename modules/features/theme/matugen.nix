{pkgs, ...}: {
  flake.modules.nixos.theme = {
    environment.systemPackages = [
      pkgs.matugen
    ];
  };
}
