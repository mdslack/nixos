{...}: {
  flake.modules.nixos.features.shell.bash = {
    programs.bash.enable = true;
  };

  flake.modules.homeManager.features.shell.bash = {
    programs.bash = {
      enable = true;
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
      };
      shellAliases = {
        ll = "ls -alF";
        la = "ls -A";
        gs = "git status -sb";
      };
    };
  };
}
