{ inputs, lib, ... }:
{
  flake.modules.nixos.session-dms =
    { pkgsUnstable, ... }:
    {
      imports = [
        inputs.dms.nixosModules.default
      ];

      nixpkgs.overlays = [
        (_final: _prev: {
          inherit (pkgsUnstable) dgop;
        })
      ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;

        enableSystemMonitoring = true;
        enableVPN = true;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableCalendarEvents = false;
        enableClipboardPaste = true;
      };

    };

  flake.modules.homeManager.session-dms =
    { config, ... }:
    {
      xdg.configFile."niri/config.kdl".enable = lib.mkForce false;

      xdg.configFile."DankMaterialShell" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dms";
        recursive = true;
      };
    };
}
