_: {
  flake.modules.nixos.desktop-cosmic =
    { pkgs, ... }:
    {
      services.displayManager."cosmic-greeter".enable = true;
      services.desktopManager.cosmic.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-cosmic ];
      };
    };
}
