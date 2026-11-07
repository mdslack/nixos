{ config, ... }:
{
  flake.modules.nixos.bundle-session-noctalia-greeter = {
    imports = [ config.flake.modules.nixos.session-noctalia-greeter ];
    home-manager.sharedModules = [ config.flake.modules.homeManager.session-noctalia-greeter ];
  };
}
