{ lib, pkgs, hostname, username, ... }:
let
  pkgFromPaths = paths:
    lib.findFirst
      (p: p != null)
      null
      (map (path: lib.attrByPath path null pkgs) paths);

  fcitx5Rime = pkgFromPaths [ [ "qt6Packages" "fcitx5-rime" ] [ "kdePackages" "fcitx5-rime" ] [ "fcitx5-rime" ] ];
  fcitx5Gtk = pkgFromPaths [ [ "qt6Packages" "fcitx5-gtk" ] [ "kdePackages" "fcitx5-gtk" ] [ "fcitx5-gtk" ] ];
  fcitx5ChineseAddons = pkgFromPaths [ [ "qt6Packages" "fcitx5-chinese-addons" ] [ "kdePackages" "fcitx5-chinese-addons" ] [ "fcitx5-chinese-addons" ] ];
  fcitx5Qt = pkgFromPaths [ [ "qt6Packages" "fcitx5-qt" ] [ "kdePackages" "fcitx5-qt" ] [ "fcitx5-qt" ] ];
  fcitx5Wayland = pkgFromPaths [ [ "qt6Packages" "fcitx5-wayland" ] [ "kdePackages" "fcitx5-wayland" ] [ "fcitx5-wayland" ] ];
  fcitx5Configtool = pkgFromPaths [ [ "qt6Packages" "fcitx5-configtool" ] [ "kdePackages" "fcitx5-configtool" ] [ "fcitx5-configtool" ] ];
in {
  imports = [
    ./apps.nix
    ./dev-tooling.nix
    ./services.nix
  ];

  workstation.apps = {
    enable = true;
    enableBravePwas = true;
    enableSpotify = true;
    enableNautilus = true;
    enableGnomeDesktop = true;
    enableDropbox = false;
    enableDropboxWithNautilus = false;
    enableMaestral = true;
    enableMaestralGui = true;
    enableZed = true;
  };

  workstation.devTooling = {
    enable = true;
    enableVmManager = false;
    enableTexLive = true;
    enableAiCli = true;
  };

  workstation.services = {
    enable = true;
    enableTailscale = true;
    enableProtonVpn = true;
    enableProtonVpnCli = true;
  };

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
    fcitx5.addons = lib.filter (x: x != null) [
      fcitx5Rime
      fcitx5Gtk
      fcitx5ChineseAddons
      fcitx5Qt
      fcitx5Wayland
    ];
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
    # Temporarily disabled to avoid khal build/install failures.
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
      git
      gh
      rime-data
      vim
      wget
    ]
    ++ lib.optionals (fcitx5Configtool != null) [ fcitx5Configtool ]
    ++ lib.optionals (pkgs ? dms-cli) [ dms-cli ];

  warnings =
    lib.optionals (fcitx5Rime == null) [
      "No fcitx5-rime package found in qt6Packages/kdePackages/top-level pkgs; Rime input will be unavailable."
    ];

}
