{inputs, ...}: let
  pluginPkgs = inputs.nixpkgs.legacyPackages.x86_64-linux.vimPlugins;
in {
  # Included in default editor baseline.
  flake.modules.homeManager.editor-nvf = {pkgs, ...}: {
    imports = [inputs.nvf.homeManagerModules.nvf];

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
            "<leader>fr" = {
              action = "<cmd>Telescope oldfiles<cr>";
              desc = "Recent files";
            };
            "<leader>mp" = {
              action = "<cmd>MarkdownPreviewToggle<cr>";
              desc = "Markdown preview";
            };
            "<leader>mr" = {
              action = "<cmd>RenderMarkdown buf_toggle<cr>";
              desc = "Render markdown";
            };
            "<leader>xx" = {
              action = "<cmd>Trouble toggle diagnostics<cr>";
              desc = "Trouble";
            };
            "<leader>gs" = {
              action = "<cmd>Neotree toggle git_status<cr>";
              desc = "Git status tree";
            };
            "<leader>gh" = {
              action = "<cmd>Gitsigns preview_hunk<cr>";
              desc = "Preview git hunk";
            };
            "<leader>ca" = {
              action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
              desc = "Code action";
            };
            "<leader>bd" = {
              action = "<cmd>bdelete<cr>";
              desc = "Delete buffer";
            };
            "H" = {
              action = "<cmd>bprevious<cr>";
              desc = "Previous buffer";
            };
            "L" = {
              action = "<cmd>bnext<cr>";
              desc = "Next buffer";
            };
            "<leader>b1" = {
              action = "<cmd>BufferLineGoToBuffer 1<cr>";
              desc = "Go to buffer 1";
            };
            "<leader>b2" = {
              action = "<cmd>BufferLineGoToBuffer 2<cr>";
              desc = "Go to buffer 2";
            };
            "<leader>b3" = {
              action = "<cmd>BufferLineGoToBuffer 3<cr>";
              desc = "Go to buffer 3";
            };
            "<leader>b4" = {
              action = "<cmd>BufferLineGoToBuffer 4<cr>";
              desc = "Go to buffer 4";
            };
            "<leader>b5" = {
              action = "<cmd>BufferLineGoToBuffer 5<cr>";
              desc = "Go to buffer 5";
            };
            "<leader>b6" = {
              action = "<cmd>BufferLineGoToBuffer 6<cr>";
              desc = "Go to buffer 6";
            };
            "<leader>b7" = {
              action = "<cmd>BufferLineGoToBuffer 7<cr>";
              desc = "Go to buffer 7";
            };
            "<leader>b8" = {
              action = "<cmd>BufferLineGoToBuffer 8<cr>";
              desc = "Go to buffer 8";
            };
            "<leader>b9" = {
              action = "<cmd>BufferLineGoToBuffer 9<cr>";
              desc = "Go to buffer 9";
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
          autocomplete.nvim-cmp = {
            enable = true;
            mappings.complete = "<C-.>";
            sourcePlugins = [pluginPkgs.cmp-cmdline];
            setupOpts = {
              completion.completeopt = "menu,menuone,noselect";
              experimental.ghost_text = true;
            };
          };
          luaConfigPost = ''
            local ok_cmp, cmp = pcall(require, "cmp")
            if ok_cmp then
              cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                  { name = "buffer" },
                },
              })

              cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                  { name = "path" },
                }, {
                  { name = "cmdline" },
                }),
              })
            end

            vim.opt.clipboard = "unnamedplus"
          '';

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
            enableDAP = true;

            rust = {
              enable = true;
              lsp.enable = true;
              format.enable = true;
            };
            python = {
              enable = true;
              lsp = {
                enable = true;
                servers = ["basedpyright"];
              };
              format = {
                enable = true;
                type = ["ruff"];
              };
            };
            nix = {
              enable = true;
              lsp.enable = true;
              format = {
                enable = true;
                type = ["alejandra"];
              };
              extraDiagnostics = {
                enable = true;
                types = ["statix"];
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
              extensions.render-markdown-nvim.enable = true;
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
          tabline.nvimBufferline = {
            enable = true;
            setupOpts.options.numbers = "ordinal";
          };

          binds.whichKey.enable = true;
          autopairs.nvim-autopairs.enable = true;
          comments.comment-nvim.enable = true;
          utility.surround = {
            enable = true;
            useVendoredKeybindings = false;
          };
          utility.preview.markdownPreview.enable = true;
          visuals.indent-blankline.enable = true;

          diagnostics.nvim-lint = {
            enable = true;
            lint_after_save = true;
            linters_by_ft = {
              rust = ["clippy"];
              python = ["ruff"];
              go = ["golangcilint"];
              typescript = ["eslint"];
              typescriptreact = ["eslint"];
              javascript = ["eslint"];
              javascriptreact = ["eslint"];
              lua = ["luacheck"];
              markdown = ["markdownlint"];
            };
          };

          formatter.conform-nvim = {
            setupOpts.formatters.deno_fmt = {
              command = "${pkgs.deno}/bin/deno";
              append_args = [
                "--line-width"
                "80"
              ];
            };
          };

          git = {
            enable = true;
            gitsigns.enable = true;
          };

          terminal.toggleterm = {
            enable = true;
            lazygit.enable = true;
          };

          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            trouble.enable = true;
            lspSignature.enable = true;
          };

          debugger.nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };
      };
    };
  };
}
