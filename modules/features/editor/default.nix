{config, ...}: {
  flake.modules.nixos.features.editor = {
    imports = [
      config.flake.modules.nixos.features.editor.neovim
      config.flake.modules.nixos.features.editor.zed
    ];
  };

  flake.modules.homeManager.features.editor = {
    imports = [
      config.flake.modules.homeManager.features.editor.nvf
      config.flake.modules.homeManager.features.editor.zed
    ];
  };
}
