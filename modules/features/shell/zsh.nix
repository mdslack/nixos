_: {
  flake.modules.nixos.shell-zsh = { lib, pkgs, ... }: {
    programs.zsh.enable = true;
    programs.zsh.ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
      ];
    };
    users.defaultUserShell = lib.mkForce pkgs.zsh;
  };

  flake.modules.homeManager.shell-zsh = { config, pkgs, ... }: {
    home.file.".config/zsh/dotfiles.zsh".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "zsh-autocomplete";
          src = pkgs.zsh-autocomplete;
          file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
        }
      ];
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
      initContent = ''
        setopt prompt_subst

        if [ -f "$HOME/.config/zsh/dotfiles.zsh" ]; then
          source "$HOME/.config/zsh/dotfiles.zsh"
        fi

        if [ -n "$ZSH_THEME" ] && [ -r "$ZSH/themes/$ZSH_THEME.zsh-theme" ]; then
          source "$ZSH/themes/$ZSH_THEME.zsh-theme"
        fi

        nix_shell_prompt() {
          if [[ -n "$IN_NIX_SHELL" ]]; then
            local tag="nix"
            local color="''${NIX_SHELL_PROMPT_COLOR:-cyan}"

            if [[ -n "$NIX_DEVSHELL_NAME" ]]; then
              tag="dev:$NIX_DEVSHELL_NAME"
            fi

            printf '%%F{%s}[%s]%%f ' "$color" "$tag"
          fi
        }

        PROMPT='$(nix_shell_prompt)'"''${PROMPT}"
      '';
    };
  };
}
