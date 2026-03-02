{...}: {
  flake.modules.nixos.ai-claude = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs."claude-code"
    ];
  };
}
