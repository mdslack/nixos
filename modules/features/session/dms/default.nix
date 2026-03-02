{inputs, ...}: {
  flake.modules.nixos.features.session.dms = {
    imports = [
      inputs.dms.nixosModules.dank-material-shell
      inputs.dms.nixosModules.greeter
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

    programs.dsearch.enable = true;
  };

  flake.modules.homeManager.features.session.dms = {
    xdg.configFile."DankMaterialShell/settings.json".source = ./settings.json;
    xdg.configFile."DankMaterialShell/.firstlaunch".text = "";
    xdg.configFile."DankMaterialShell/.changelog-1.4".text = "";
  };
}
