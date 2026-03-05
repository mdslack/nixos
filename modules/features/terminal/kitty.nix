_: {
  flake.modules.nixos.terminal-kitty =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.kitty
      ];
    };

  flake.modules.homeManager.terminal-kitty = { config, ... }: {
    xdg.configFile."kitty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/kitty";
      recursive = true;
    };
  };
}
