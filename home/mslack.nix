{ config, lib, pkgs, username, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  yaziCatppuccinMocha = pkgs.callPackage ../packages/yazi-flavors/catppuccin-mocha.nix { };

  managedXdgEntries = {
    "DankMaterialShell" = { source = "dms/.config/DankMaterialShell"; recursive = true; };
    "nvim" = { source = "lazyvim/.config/nvim"; recursive = true; };
    "zed" = { source = "zed/.config/zed"; recursive = true; };
    "markdown" = { source = "markdown/.config/markdown"; recursive = true; };
  };

  managedHomeEntries = {
    ".zshrc" = { source = "zsh/.zshrc"; };
    ".bashrc" = { source = "bash/.bashrc"; };
    ".gitconfig" = { source = "git/.gitconfig"; };
    ".ssh/config" = { source = "ssh/.ssh/config"; };
    ".opencode/opencode.jsonc" = { source = "opencode/.opencode/opencode.jsonc"; };
  };
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    zed-editor
  ];

  programs.yazi = {
    enable = true;
    flavors = {
      catppuccin-mocha = yaziCatppuccinMocha;
    };
    theme = {
      flavor = {
        dark = "catppuccin-mocha";
        light = "catppuccin-mocha";
      };
    };
  };

  xdg.configFile = builtins.listToAttrs (
    map (name:
      let
        entry = managedXdgEntries.${name};
      in {
        name = name;
        value = {
          source = mkOutOfStoreSymlink "${dotfilesRoot}/${entry.source}";
          recursive = entry.recursive or false;
          force = true;
        };
      })
    (builtins.attrNames managedXdgEntries)
  );

  home.file =
    {
      ".oh-my-zsh".source = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
    }
    // builtins.listToAttrs (
      map (name:
        let
          entry = managedHomeEntries.${name};
        in {
          name = name;
          value = {
            source = mkOutOfStoreSymlink "${dotfilesRoot}/${entry.source}";
            recursive = entry.recursive or false;
            force = true;
          };
        })
      (builtins.attrNames managedHomeEntries)
    );

  home.activation.installOhMyZshPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ZSH_CUSTOM="${config.home.homeDirectory}/.oh-my-zsh-custom"
    mkdir -p "$ZSH_CUSTOM/plugins"

    if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" || true
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete" || true
    fi
  '';

  systemd.user.services.gnome-keyring-daemon = {
    Unit = {
      Description = "GNOME Keyring daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --foreground --components=secrets";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
