{config, ...}: {
  flake.modules.nixos.users.mslack = {
    users.users.mslack = {
      isNormalUser = true;
      description = "mslack";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };

    home-manager.users.mslack = {
      imports = [
        config.flake.modules.homeManager.features.browser
        config.flake.modules.homeManager.features.cloud.maestral
        config.flake.modules.homeManager.features.editor
        config.flake.modules.homeManager.features.files
        config.flake.modules.homeManager.features.shell
        config.flake.modules.homeManager.features.terminal
      ];
    };
  };
}
