{ inputs, ... }:
{
  # Included in default editor baseline.
  flake.modules.homeManager.editor-nvf = {
    imports = [ inputs.nvf.homeManagerModules.nvf ];

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
