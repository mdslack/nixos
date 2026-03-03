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
          globals.mapleader = " ";

          maps.normal = {
            "<leader>e" = {
              action = "<cmd>Neotree toggle<cr>";
              desc = "File tree";
            };
            "<leader>t" = {
              action = "<cmd>ToggleTerm<cr>";
              desc = "Terminal";
            };
            "<leader>xx" = {
              action = "<cmd>Trouble toggle diagnostics<cr>";
              desc = "Trouble";
            };
            "<C-h>" = {
              action = "<C-w>h";
              desc = "Focus left";
            };
            "<C-j>" = {
              action = "<C-w>j";
              desc = "Focus down";
            };
            "<C-k>" = {
              action = "<C-w>k";
              desc = "Focus up";
            };
            "<C-l>" = {
              action = "<C-w>l";
              desc = "Focus right";
            };
            "<C-Up>" = {
              action = "<cmd>resize +2<cr>";
              desc = "Resize taller";
            };
            "<C-Down>" = {
              action = "<cmd>resize -2<cr>";
              desc = "Resize shorter";
            };
            "<C-Left>" = {
              action = "<cmd>vertical resize -2<cr>";
              desc = "Resize narrower";
            };
            "<C-Right>" = {
              action = "<cmd>vertical resize +2<cr>";
              desc = "Resize wider";
            };
          };

          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
          };

          telescope.enable = true;
          filetree.neo-tree = {
            enable = true;
            setupOpts = {
              default_source = "filesystem";
              enable_diagnostics = true;
              enable_git_status = true;
              enable_modified_markers = true;
              enable_opened_markers = true;
              enable_refresh_on_write = true;
              filesystem.hijack_netrw_behavior = "open_current";
              window.mappings = {
                "<space>" = "none";
              };
            };
          };

          treesitter = {
            enable = true;
          };

          languages = {
            enableTreesitter = true;

            rust = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            python = {
              enable = true;
              lsp = {
                enable = true;
                servers = [ "basedpyright" ];
              };
              format = {
                enable = true;
                type = "ruff";
              };
            };
            nix = {
              enable = true;
              lsp.enable = true;
              format = {
                enable = true;
                type = "alejandra";
              };
              extraDiagnostics = {
                enable = true;
                types = [ "statix" ];
              };
            };
            go = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            ts = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            markdown = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            lua = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            json = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            yaml = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            toml = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            bash = {
              enable = true;
              lsp.enable = true;
            };
            html = {
              enable = true;
              lsp.enable = false;
            };
            css = {
              enable = true;
              lsp.enable = false;
            };
          };

          statusline.lualine.enable = true;
          tabline.nvimBufferline.enable = true;

          binds.whichKey.enable = true;
          autopairs.nvim-autopairs.enable = true;
          comments.comment-nvim.enable = true;
          visuals.indent-blankline.enable = true;

          diagnostics.nvim-lint = {
            enable = true;
            lint_after_save = true;
            linters_by_ft = {
              rust = [ "clippy" ];
              python = [ "ruff" ];
              go = [ "golangcilint" ];
              typescript = [ "eslint" ];
              typescriptreact = [ "eslint" ];
              javascript = [ "eslint" ];
              javascriptreact = [ "eslint" ];
              lua = [ "luacheck" ];
              markdown = [ "markdownlint" ];
            };
          };

          git = {
            enable = true;
            gitsigns.enable = true;
          };

          terminal.toggleterm.enable = true;

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
