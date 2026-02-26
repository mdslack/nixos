{ config, username, ... }:
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

  existingXdgEntryNames = builtins.filter
    (name: builtins.pathExists "${dotfilesRoot}/${managedXdgEntries.${name}.source}")
    (builtins.attrNames managedXdgEntries);

  managedHomeEntries = {
    ".zshrc" = { source = "zsh/.zshrc"; };
    ".bashrc" = { source = "bash/.bashrc"; };
    ".gitconfig" = { source = "git/.gitconfig"; };
    ".ssh/config" = { source = "ssh/.ssh/config"; };
    ".opencode/opencode.jsonc" = { source = "opencode/.opencode/opencode.jsonc"; };
  };

  existingHomeEntryNames = builtins.filter
    (name: builtins.pathExists "${dotfilesRoot}/${managedHomeEntries.${name}.source}")
    (builtins.attrNames managedHomeEntries);
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = [ ];

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
    existingXdgEntryNames
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
    existingHomeEntryNames
  );
}
