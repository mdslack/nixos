{pkgs, ...}: {
  flake.modules.nixos.features.wm.niri = {
    programs.niri.enable = true;

    services.greetd.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      grim
      mako
      pamixer
      playerctl
      slurp
      swww
      swaylock
      swappy
      waybar
      wl-clipboard
      wlr-randr
      xwayland-satellite
    ];
  };

  flake.modules.homeManager.features.wm.niri = {
    home.sessionVariables.TERMINAL = "ghostty";

    programs.niri = {
      enable = true;
      settings = {
        prefer-no-csd = true;
      };
    };
  };
}
