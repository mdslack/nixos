{...}: {
  flake.modules.nixos.features.shell.zsh = {
    programs.zsh.enable = true;
  };

  flake.modules.homeManager.features.shell.zsh = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
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
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };
      initExtra = ''
        setopt prompt_subst

        nix_shell_prompt() {
          [[ -n "$IN_NIX_SHELL" ]] && printf '[nix:%s] ' "$IN_NIX_SHELL"
        }

        PROMPT='$(nix_shell_prompt)'"''${PROMPT}"
      '';
    };
  };
}
