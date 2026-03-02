{pkgs, ...}: {
  flake.modules.nixos.features.media.spotify = {
    environment.systemPackages = [
      pkgs.spotify
    ];
  };
}
