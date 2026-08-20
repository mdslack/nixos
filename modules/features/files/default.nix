{ config, ... }:
{
  flake.modules.nixos.files-removable = {
    # Provides the privileged disk operations used by the per-user automounter.
    services.udisks2.enable = true;
  };

  flake.modules.homeManager.files-removable =
    { pkgs, ... }:
    let
      udiskieTrayIcon = pkgs.writeText "udiskie-tray.svg" ''
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 22 22">
          <path fill="#ffffff" d="M11 4 17 13H5l6-9z"/>
          <rect fill="#ffffff" x="5" y="15" width="12" height="3" rx="1"/>
        </svg>
      '';
    in
    {
      services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "auto";
        settings.icon_names.media = "${udiskieTrayIcon}";
      };
    };

  flake.modules.nixos.files = {
    imports = [
      config.flake.modules.nixos.files-archives
      config.flake.modules.nixos.files-removable
      config.flake.modules.nixos.files-yazi
    ];
  };

  flake.modules.homeManager.files = {
    imports = [
      config.flake.modules.homeManager.files-removable
      config.flake.modules.homeManager.files-yazi
    ];
  };
}
