{ config, ... }:
{
  flake.modules.nixos.terminal = {
    imports = [
      config.flake.modules.nixos.terminal-fonts
      config.flake.modules.nixos.terminal-alacritty
      config.flake.modules.nixos.terminal-ghostty
      config.flake.modules.nixos.terminal-kitty
    ];
  };

  flake.modules.homeManager.terminal = {
    imports = [
      config.flake.modules.homeManager.terminal-alacritty
      config.flake.modules.homeManager.terminal-ghostty
      config.flake.modules.homeManager.terminal-kitty
    ];
  };
}
