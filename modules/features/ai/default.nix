{ config, ... }:
{
  flake.modules.nixos.ai = {
    imports = [
      config.flake.modules.nixos.ai-codex
      config.flake.modules.nixos.ai-claude
    ];
  };

  flake.modules.homeManager.ai = {
    imports = [
      config.flake.modules.homeManager.ai-codex
    ];
  };
}
