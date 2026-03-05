_: {
  flake.modules.nixos.terminal-alacritty =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.alacritty
      ];
    };

  flake.modules.homeManager.terminal-alacritty = { config, ... }: {
    xdg.configFile."alacritty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty";
      recursive = true;
    };

    programs.alacritty = {
      enable = true;
    };
  };
}
