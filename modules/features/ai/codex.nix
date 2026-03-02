{...}: {
  flake.modules.nixos.ai-codex = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.codex
    ];
  };
}
