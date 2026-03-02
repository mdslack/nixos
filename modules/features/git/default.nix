{...}: {
  flake.modules.homeManager.git = {
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
