{...}: {
  flake.modules.nixos.media-spotify = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.spotify
    ];
  };
}
