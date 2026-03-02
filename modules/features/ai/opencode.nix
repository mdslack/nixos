{pkgs, ...}: {
  flake.modules.nixos.features.ai.opencode = {
    environment.systemPackages = [
      pkgs.opencode
    ];
  };
}
