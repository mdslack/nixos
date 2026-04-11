_: {
  flake.modules.homeManager.cloud-rclone = { config, ... }: {
    xdg.configFile."rclone/rclone.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/rclone/rclone.conf";
  };
}
