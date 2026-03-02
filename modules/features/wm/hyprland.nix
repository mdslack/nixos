{...}: {
  flake.modules.nixos.wm-hyprland = {pkgs, ...}: {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services.greetd.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      grim
      hypridle
      hyprlock
      mako
      pamixer
      playerctl
      slurp
      swww
      swappy
      waybar
      wl-clipboard
    ];
  };
}
