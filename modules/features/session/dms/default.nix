{inputs, lib, ...}: {
  flake.modules.nixos.session-dms = {pkgsUnstable, ...}: {
    imports = [
      inputs.dms.nixosModules.default
    ];

    nixpkgs.overlays = [
      (final: prev: {
        dgop = pkgsUnstable.dgop;
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

  flake.modules.homeManager.session-dms = {
    xdg.configFile."niri/config.kdl".enable = lib.mkForce false;

    xdg.configFile."DankMaterialShell/settings.json".source = ./settings.json;
    xdg.configFile."DankMaterialShell/.firstlaunch".text = "";
    xdg.configFile."DankMaterialShell/.changelog-1.4".text = "";
  };
}
