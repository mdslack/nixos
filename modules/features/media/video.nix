_: {
  flake.modules.nixos.media-video =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.kdePackages.kdenlive
      ];
    };
}
