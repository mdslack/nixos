{...}: {
  flake.modules.nixos.ai-gemini = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs."gemini-cli"
    ];
  };
}
