_: {
  flake.modules.homeManager.git =
    { config, ... }:
    {
      xdg.configFile."lazygit/config.yml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/lazygit/config.yml";

      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user = {
            name = "Michael Slack";
            email = "mike@mslack.com";
          };
          init.defaultBranch = "main";
          core = {
            autocrlf = false;
            ignorecase = false;
          };
        };
      };

      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
      };
    };
}
