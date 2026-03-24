_: {
  flake.modules.nixos.media-publishing = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      calibre
      epubcheck
    ];
  };
}
