{ lib, pkgs, hostname, username, ... }:
{
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

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

    greeter = {
      enable = false;
      compositor.name = "niri";
      configHome = "/home/${username}";
    };
  };

  services.greetd.enable = lib.mkForce false;

  programs.dsearch.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
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
      vim
      wget
    ]
    ++ lib.optionals (pkgs ? dms-cli) [ dms-cli ];

}
