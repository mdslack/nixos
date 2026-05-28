_: {
  # Included in default editor baseline.
  flake.modules.nixos.editor-neovim =
    { pkgs, pkgsUnstable, ... }:
    {
      environment.systemPackages = [
        pkgsUnstable.neovim
        pkgs.basedpyright
        pkgs.bash-language-server
        pkgs.fd
        pkgs.gopls
        pkgs.lazygit
        pkgs.lua-language-server
        pkgs.marksman
        pkgs.nil
        pkgs.nixfmt-rfc-style
        pkgs.prettier
        pkgs.python3Packages.pylatexenc
        pkgs.ripgrep
        pkgs.ruff
        pkgs.shfmt
        pkgs.rust-analyzer
        pkgs.stylua
        pkgs.taplo
        pkgs.typescript-language-server
        pkgs.vscode-langservers-extracted
        pkgs.wl-clipboard
        pkgs.xclip
        pkgs.yaml-language-server
      ];
    };

  flake.modules.homeManager.editor-neovim =
    { config, pkgsUnstable, ... }:
    let
      grammars = pkgsUnstable.tree-sitter-grammars;
      nvimTreesitter = pkgsUnstable.vimPlugins.nvim-treesitter;

      parsers = {
        bash = grammars.tree-sitter-bash;
        css = grammars.tree-sitter-css;
        go = grammars.tree-sitter-go;
        html = grammars.tree-sitter-html;
        javascript = grammars.tree-sitter-javascript;
        json = grammars.tree-sitter-json;
        latex = grammars.tree-sitter-latex;
        lua = grammars.tree-sitter-lua;
        nix = grammars.tree-sitter-nix;
        python = grammars.tree-sitter-python;
        rust = grammars.tree-sitter-rust;
        toml = grammars.tree-sitter-toml;
        tsx = grammars.tree-sitter-tsx;
        typescript = grammars.tree-sitter-typescript;
        yaml = grammars.tree-sitter-yaml;
      };

      parserFiles = builtins.listToAttrs (
        builtins.map (language: {
          name = ".local/share/nvim/site/parser/${language}.so";
          value.source = "${parsers.${language}}/parser";
        }) (builtins.attrNames parsers)
      );

      queries = {
        bash = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        css = [
          "folds"
          "highlights"
          "indents"
          "injections"
        ];
        go = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        html = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        javascript = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        json = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        latex = [
          "folds"
          "highlights"
          "injections"
        ];
        lua = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        nix = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        python = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        rust = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        toml = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        tsx = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        typescript = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
        yaml = [
          "folds"
          "highlights"
          "indents"
          "injections"
          "locals"
        ];
      };

      queryFiles = builtins.listToAttrs (
        builtins.concatLists (
          builtins.map (
            language:
            builtins.map (query: {
              name = ".local/share/nvim/site/queries/${language}/${query}.scm";
              value.source = "${nvimTreesitter}/runtime/queries/${language}/${query}.scm";
            }) queries.${language}
          ) (builtins.attrNames queries)
        )
      );
    in
    {
      home.file = {
        ".config/nvim".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
      }
      // parserFiles
      // queryFiles;
    };
}
