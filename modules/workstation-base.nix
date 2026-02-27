{ lib, pkgs, hostname, username, ... }:
{
  imports = [
    ./apps.nix
    ./dev-tooling.nix
    ./services.nix
  ];

  workstation.devTooling.enableVmManager = false;

  system.stateVersion = "25.11";

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons =
      (with pkgs; [
        fcitx5-rime
        fcitx5-gtk
      ])
      ++ (with pkgs.qt6Packages; [
        fcitx5-chinese-addons
        fcitx5-qt
      ]);
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Wayland-native mode for Chromium/Electron apps (including Spotify).
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "input" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = true;

  services.dbus.enable = true;
  security.polkit.enable = true;
  services.gvfs.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa
    libva-vdpau-driver
    libvdpau-va-gl
  ];

  programs.niri.enable = true;

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    # Keep disabled until khal packaging is stable in our pin.
    enableCalendarEvents = false;
    enableClipboardPaste = true;
  };

  services.greetd.enable = lib.mkForce false;

  programs.dsearch.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs;
    [
      adw-gtk3
      alacritty
      brave
      btop
      curl
      ghostty
      git
      gh
      rime-data
      vim
      wget
    ]
    ++ [ pkgs.qt6Packages.fcitx5-configtool ]
    ++ lib.optionals (pkgs ? dms-cli) [ dms-cli ];

}
