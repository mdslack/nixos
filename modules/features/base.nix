_: {
  flake.modules.nixos.base = {pkgs, ...}: {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config.allowUnfree = true;

    # time.timeZone = "Asia/Taipei";
    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.UTF-8";

    security.polkit.enable = true;
    security.sudo.wheelNeedsPassword = true;

    services.dbus.enable = true;
    services.gvfs.enable = true;

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

    system.stateVersion = "25.11";
  };

  flake.modules.homeManager.base = {
    home.stateVersion = "25.11";
    home.enableNixpkgsReleaseCheck = false;
  };
}
