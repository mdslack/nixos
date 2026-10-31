_: {
  flake.modules.nixos.terminal-herdr =
    { inputs, pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

  flake.modules.homeManager.terminal-herdr =
    { config, ... }:
    {
      fonts.fontconfig.enable = true;

      home.file.".local/share/fonts/herdr/HerdrAgentIconsMax-Regular.ttf" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/herdr/fonts/HerdrAgentIconsMax-Regular.ttf";
      };

      xdg.configFile."herdr/config.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/herdr/config.toml";
      };
    };
}
