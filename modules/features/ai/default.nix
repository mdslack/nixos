{ config, ... }:
{
  flake.modules.nixos.ai = {
    imports = [
      config.flake.modules.nixos.ai-codex
      config.flake.modules.nixos.ai-claude
      config.flake.modules.nixos.ai-antigravity
    ];
  };

  flake.modules.homeManager.ai = {
    imports = [
      config.flake.modules.homeManager.ai-codex
    ];
  };
}
