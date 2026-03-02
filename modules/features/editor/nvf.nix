{inputs, ...}: {
  flake.modules.homeManager.features.editor.nvf = {
    imports = [inputs.nvf.homeManagerModules.default];

    programs.nvf = {
      enable = true;
      defaultEditor = true;

      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;

          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            trouble.enable = true;
            lspSignature.enable = true;
          };
        };
      };
    };
  };
}
