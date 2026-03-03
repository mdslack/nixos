{ config, ... }:
{
  flake.modules.nixos.shell = {
    imports = [
      config.flake.modules.nixos.shell-bash
      config.flake.modules.nixos.shell-zsh
    ];
  };

  flake.modules.homeManager.shell = {
    imports = [
      config.flake.modules.homeManager.shell-bash
      config.flake.modules.homeManager.shell-zsh
    ];
  };
}
