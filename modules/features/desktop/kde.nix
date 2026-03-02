{pkgs, ...}: {
  flake.modules.nixos.features.desktop.kde = {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
    };
  };
}
