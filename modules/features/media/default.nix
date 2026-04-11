{config, ...}: {
  flake.modules.nixos.media = {
    imports = [
      config.flake.modules.nixos.media-audio
      config.flake.modules.nixos.media-graphics
      config.flake.modules.nixos.media-publishing
      config.flake.modules.nixos.media-recording
      config.flake.modules.nixos.media-spotify
    ];
  };

  flake.modules.homeManager.media = {
    imports = [
      config.flake.modules.homeManager.media-audio
    ];
  };

  flake.modules.nixos.media-graphics = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      imagemagick
      gimp
      loupe
      inkscape
      krita
      zathura
    ];
  };
}
