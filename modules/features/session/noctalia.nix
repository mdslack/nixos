{inputs, ...}: {
  flake.modules.nixos.session-noctalia = {pkgs, ...}: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    environment.systemPackages = [
      pkgs.adwaita-icon-theme
      pkgs.hicolor-icon-theme
      pkgs.papirus-icon-theme
    ];
  };

  flake.modules.homeManager.session-noctalia = {
    config,
    lib,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = lib.mkForce {};
    };

    xdg.configFile."noctalia" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia";
      recursive = true;
    };
  };
}
