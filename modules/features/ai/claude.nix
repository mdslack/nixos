{pkgs, ...}: {
  flake.modules.nixos.features.ai.claude = {
    environment.systemPackages = [
      pkgs."claude-code"
    ];
  };
}
