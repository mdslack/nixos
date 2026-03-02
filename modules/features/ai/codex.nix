{pkgs, ...}: {
  flake.modules.nixos.features.ai.codex = {
    environment.systemPackages = [
      pkgs.codex
    ];
  };
}
