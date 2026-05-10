_: {
  flake.modules.nixos.media-video =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kdePackages.kdenlive
        mpv
      ];
    };
}
