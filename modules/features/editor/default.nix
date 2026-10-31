{ config, ... }:
{
  flake.modules.nixos.editor = {
    imports = [
      config.flake.modules.nixos.editor-libreoffice
      config.flake.modules.nixos.editor-neovim
    ];
  };

  flake.modules.homeManager.editor = {
    imports = [
      config.flake.modules.homeManager.editor-neovim
    ];
  };
}
