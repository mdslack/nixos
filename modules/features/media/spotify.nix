{pkgs, ...}: {
  flake.modules.nixos.media-spotify = {
    environment.systemPackages = [
      pkgs.spotify
    ];
  };
}
