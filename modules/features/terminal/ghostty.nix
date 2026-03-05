_: {
  flake.modules.nixos.terminal-ghostty =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.ghostty
      ];
    };

  flake.modules.homeManager.terminal-ghostty = { config, ... }: {
    xdg.configFile."ghostty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ghostty";
      recursive = true;
    };

    programs.ghostty = {
      enable = true;
    };
  };
}
