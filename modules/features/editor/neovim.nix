{...}: {
  # Included in default editor baseline.
  flake.modules.nixos.editor-neovim = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.neovim
    ];
  };
}
