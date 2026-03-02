{inputs, ...}: {
  flake.modules.nixos.features.session.noctalia = {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    programs."noctalia-shell".enable = true;
  };

  flake.modules.homeManager.features.session.noctalia = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = {
        settingsVersion = 0;
        general = {
          telemetryEnabled = false;
          showChangelogOnStartup = false;
        };
        colorSchemes = {
          useWallpaperColors = true;
          predefinedScheme = "Noctalia (default)";
          darkMode = true;
          generationMethod = "tonal-spot";
        };
      };
    };
  };
}
