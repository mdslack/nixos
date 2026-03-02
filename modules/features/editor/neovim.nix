{pkgs, ...}: {
  # Included in default editor baseline.
  flake.modules.nixos.editor-neovim = {
    environment.systemPackages = [
      pkgs.neovim
    ];
  };
}
