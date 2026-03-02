{...}: {
  flake.modules.nixos.features.ai = {
    imports = [
      ./opencode.nix
      ./codex.nix
    ];
  };
}
