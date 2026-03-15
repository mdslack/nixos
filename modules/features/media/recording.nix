_: {
  flake.modules.nixos.media-recording = {pkgs, ...}: {
    services.pipewire.jack.enable = true;

    environment.systemPackages = with pkgs; [
      audacity
      wireplumber
      ffmpeg
      jack-example-tools
      obs-studio
      qpwgraph
    ];
  };
}
