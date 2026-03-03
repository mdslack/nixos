{ config, ... }:
{
  flake.modules.nixos.users-mslack = {
    users.users.mslack = {
      isNormalUser = true;
      description = "mslack";
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
      ];
    };

    home-manager.users.mslack = {
      imports = [
        config.flake.modules.homeManager.ai
        config.flake.modules.homeManager.browser
        config.flake.modules.homeManager.cloud
        config.flake.modules.homeManager.editor
        config.flake.modules.homeManager.files
        config.flake.modules.homeManager.git
        config.flake.modules.homeManager.shell
        config.flake.modules.homeManager.terminal
        config.flake.modules.homeManager.virtualization
      ];
    };
  };
}
