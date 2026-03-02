{
  config,
  pkgs,
  ...
}: {
  flake.modules.nixos.base = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = true;

    time.timeZone = "Asia/Taipei";
    i18n.defaultLocale = "en_US.UTF-8";

    security.polkit.enable = true;
    security.sudo.wheelNeedsPassword = true;

    services.dbus.enable = true;
    services.gvfs.enable = true;

    xdg.portal.enable = true;

    environment.systemPackages = with pkgs; [
      git
      git-lfs
      gh
      lazygit
      openssh
      curl
      wget
      btop
      bat
      ripgrep
      fd
      fzf
      jq
      just
      tmux
    ];

    system.stateVersion = config.flake.meta.stateVersions.system;
  };

  flake.modules.homeManager.base = {
    home.stateVersion = config.flake.meta.stateVersions.home;
  };
}
