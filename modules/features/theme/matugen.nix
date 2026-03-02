{...}: {
  flake.modules.nixos.theme-matugen = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.matugen
    ];
  };
}
