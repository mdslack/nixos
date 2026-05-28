{ config, ... }:
{
  flake.modules.nixos.editor = {
    imports = [
      config.flake.modules.nixos.editor-libreoffice
      config.flake.modules.nixos.editor-neovim
      config.flake.modules.nixos.editor-zed
    ];
  };

  flake.modules.homeManager.editor = {
    imports = [
      config.flake.modules.homeManager.editor-neovim
      config.flake.modules.homeManager.editor-zed
    ];
  };
}
