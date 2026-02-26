{ config, pkgs, username, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;

  managedXdgEntries = {
    "DankMaterialShell" = { source = "dms/.config/DankMaterialShell"; recursive = true; };
    "nvim" = { source = "lazyvim/.config/nvim"; recursive = true; };
    "yazi" = { source = "yazi/.config/yazi"; recursive = true; };
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
    oh-my-zsh
    yazi
    neovim
    zed-editor
  ];

  xdg.configFile = builtins.listToAttrs (
    map (name:
      let
        entry = managedXdgEntries.${name};
      in {
        name = name;
        value = {
          source = mkOutOfStoreSymlink "${dotfilesRoot}/${entry.source}";
          recursive = entry.recursive or false;
        };
      })
    (builtins.attrNames managedXdgEntries)
  );

  home.file = builtins.listToAttrs (
    map (name:
      let
        entry = managedHomeEntries.${name};
      in {
        name = name;
        value = {
          source = mkOutOfStoreSymlink "${dotfilesRoot}/${entry.source}";
          recursive = entry.recursive or false;
        };
      })
    (builtins.attrNames managedHomeEntries)
  );

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
