{ pkgs, ... }:
{
  flake.modules.nixos.desktop-cosmic = {
    services.displayManager."cosmic-greeter".enable = true;
    services.desktopManager.cosmic.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-cosmic ];
    };
  };
}
