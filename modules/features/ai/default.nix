{config, ...}: {
  flake.modules.nixos.ai = {
    imports = [
      config.flake.modules.nixos.ai-opencode
      config.flake.modules.nixos.ai-codex
    ];
  };

  flake.modules.homeManager.ai = {
    imports = [
      config.flake.modules.homeManager.ai-opencode
    ];
  };
}
