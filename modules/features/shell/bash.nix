_: {
  flake.modules.nixos.shell-bash = {
    programs.bash.enable = true;
  };

  flake.modules.homeManager.shell-bash = { config, ... }: {
    home.file.".config/bash/dotfiles.bash".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/bash/.bashrc";

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
      initExtra = ''
        if [ -f "$HOME/.config/bash/dotfiles.bash" ]; then
          source "$HOME/.config/bash/dotfiles.bash"
        fi
      '';
    };
  };
}
