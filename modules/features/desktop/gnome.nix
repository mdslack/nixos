{ pkgs, ... }:
{
  flake.modules.nixos.desktop-gnome = {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    programs.dconf.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.gdm.enableGnomeKeyring = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };

    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];
  };
}
