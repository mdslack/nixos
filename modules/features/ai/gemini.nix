{pkgs, ...}: {
  flake.modules.nixos.features.ai.gemini = {
    environment.systemPackages = [
      pkgs.gemini-cli
    ];
  };
}
