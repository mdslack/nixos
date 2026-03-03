{ inputs, ... }:
{
  flake.modules.nixos.session-noctalia = {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    services.noctalia-shell.enable = true;
  };

  flake.modules.homeManager.session-noctalia =
    { config, lib, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;
        settings = lib.mkForce { };
      };

      xdg.configFile."noctalia" = {
      	source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia";
	recursive = true;
      };
    };
}
