{ ... }:
{
  flake.modules.nixos.wm-niri =
    { pkgs, ... }:
    {
      programs.niri.enable = true;

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "greeter";
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          };
        };
      };
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.greetd.enableGnomeKeyring = true;
      security.pam.services.login.enableGnomeKeyring = true;

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

  flake.modules.homeManager.wm-niri =
    { config, lib, ... }:
    {
      home.sessionVariables.TERMINAL = "ghostty";

      xdg.configFile."niri" = {
      	source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/niri";
	recursive = true;
      };
    };
}
