{pkgs, ...}: {
  flake.modules.nixos.features.editor.neovim = {
    environment.systemPackages = [
      pkgs.neovim
    ];
  };
}
