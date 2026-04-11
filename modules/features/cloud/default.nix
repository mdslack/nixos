{ config, ... }:
{
  flake.modules.nixos.cloud = {
    imports = [
      config.flake.modules.nixos.cloud-maestral
    ];
  };

  flake.modules.homeManager.cloud = {
    imports = [
      config.flake.modules.homeManager.cloud-maestral
      config.flake.modules.homeManager.cloud-rclone
    ];
  };
}
