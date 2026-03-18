{config, ...}: {
  flake.modules.nixos.media = {
    imports = [
      config.flake.modules.nixos.media-graphics
      config.flake.modules.nixos.media-recording
      config.flake.modules.nixos.media-spotify
    ];
  };

  flake.modules.nixos.media-graphics = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      imagemagick
      gimp
      inkscape
      krita
      zathura
    ];
  };
}
