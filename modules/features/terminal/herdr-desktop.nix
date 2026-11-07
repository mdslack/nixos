_:
let
  mkPackages = pkgs: rec {
    herdr-core = pkgs.callPackage ../../../packages/herdr-core.nix { };
    herdr-app = pkgs.callPackage ../../../packages/herdr-app.nix { inherit herdr-core; };
  };
  mkNotifications =
    pkgs:
    pkgs.writeShellApplication {
      name = "herdr-notifications";
      runtimeInputs = [
        (mkPackages pkgs).herdr-core
        pkgs.libnotify
        pkgs.python3
      ];
      text = ''
        exec python3 ${./herdr-notifications.py}
      '';
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages = mkPackages pkgs // {
        herdr-notifications = mkNotifications pkgs;
      };
    };

  flake.modules.nixos.terminal-herdr-desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = builtins.attrValues (mkPackages pkgs);
    };

  flake.modules.homeManager.terminal-herdr-desktop =
    { config, pkgs, ... }:
    let
      dotfiles = "${config.home.homeDirectory}/dotfiles/herdr-app";
      notifications = mkNotifications pkgs;
    in
    {
      # Link personal files individually; Herdr maintains generated assets and
      # session state beside them, including its bundled themes.
      xdg.configFile = {
        "herdr-app/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/settings.json";
        "herdr-app/keys.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/keys.json";
        "herdr-app/themes/catppuccin-mocha.json".source =
          config.lib.file.mkOutOfStoreSymlink "${dotfiles}/themes/catppuccin-mocha.json";
      };

      systemd.user.services.herdr-notifications = {
        Unit = {
          Description = "Herdr Desktop agent notifications";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${notifications}/bin/herdr-notifications";
          Restart = "always";
          RestartSec = 5;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
