{pkgs, ...}: {
  # Included in default editor baseline.
  flake.modules.nixos.editor-zed = {
    environment.systemPackages = [
      pkgs.zed-editor
    ];
  };

  # Included in default editor baseline.
  flake.modules.homeManager.editor-zed = {
    programs.zed-editor = {
      enable = true;
      package = null;
      mutableUserSettings = false;
      mutableUserKeymaps = false;

      userSettings = {
        languages = {
          Markdown = {
            format_on_save = "on";
            formatter = {
              external = {
                command = "prettier";
                arguments = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            };
          };
          Python = {
            language_servers = [
              "basedpyright"
              "ruff"
            ];
            code_actions_on_format = {
              "source.organizeImports.ruff" = true;
              "source.fixAll.ruff" = true;
            };
          };
        };

        lsp = {
          basedpyright = {
            settings = {
              "basedpyright.analysis" = {
                typeCheckingMode = "recommended";
                diagnosticMode = "openFilesOnly";
                autoSearchPaths = true;
                useLibraryCodeForTypes = true;
                reportMissingImports = "warning";
                reportMissingTypeStubs = false;
                reportUnknownMemberType = "warning";
                reportUnknownParameterType = "warning";
                reportUnknownArgumentType = "warning";
              };
            };
          };

          ruff = {
            initialization_options = {
              settings = {
                lint = {
                  select = [
                    "E"
                    "F"
                    "W"
                    "I"
                    "B"
                    "UP"
                  ];
                  ignore = ["E501"];
                };
                format = {
                  "quote-style" = "double";
                  "indent-style" = "space";
                  "docstring-code-format" = true;
                };
              };
            };
          };
        };

        session.trust_all_worktrees = true;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        vim_mode = true;
        icon_theme = {
          mode = "dark";
          light = "Catppuccin Latte";
          dark = "Catppuccin Mocha";
        };
        ui_font_size = 16;
        buffer_font_size = 15;
        theme = {
          mode = "dark";
          light = "Catppuccin Latte";
          dark = "Catppuccin Mocha";
        };
      };

      userKeymaps = [
        {
          bindings = {
            "ctrl-f" = "workspace::ToggleZoom";
            "ctrl-h" = "workspace::ActivatePaneLeft";
            "ctrl-j" = "workspace::ActivatePaneDown";
            "ctrl-k" = "workspace::ActivatePaneUp";
            "ctrl-l" = "workspace::ActivatePaneRight";
            "ctrl-n" = "workspace::ActivateNextPane";
            "ctrl-p" = "workspace::ActivatePreviousPane";
            "ctrl-]" = "workspace::ActivateNextWindow";
            "ctrl-[" = "workspace::ActivatePreviousWindow";
            "ctrl-a" = "agent::ToggleFocus";
            "ctrl-b" = "project_panel::ToggleFocus";
            "ctrl-e" = "editor::ToggleFocus";
            "ctrl-g" = "git_panel::ToggleFocus";
            "ctrl-t" = "terminal_panel::ToggleFocus";
          };
        }
        {
          context = "Editor && !AgentPanel";
          bindings = {
            "ctrl-alt-w" = "pane::CloseCleanItems";
            "ctrl-shift-c" = "workspace::CloseAllDocks";
          };
        }
        {
          context = "!Terminal";
          bindings = {
            "ctrl-shift-c" = "workspace::CloseActiveDock";
          };
        }
        {
          context = "AgentPanel";
          bindings = {
            "ctrl-shift-c" = "workspace::CloseActiveDock";
          };
        }
        {
          context = "ProjectPanel || GitPanel";
          bindings = {
            "ctrl-shift-right" = "workspace::IncreaseActiveDockSize";
            "ctrl-shift-left" = "workspace::DecreaseActiveDockSize";
          };
        }
        {
          context = "AgentPanel";
          bindings = {
            "ctrl-shift-left" = "workspace::IncreaseActiveDockSize";
            "ctrl-shift-right" = "workspace::DecreaseActiveDockSize";
          };
        }
        {
          context = "TerminalPanel";
          bindings = {
            "ctrl-shift-up" = "workspace::IncreaseActiveDockSize";
            "ctrl-shift-down" = "workspace::DecreaseActiveDockSize";
          };
        }
        {
          context = "Editor && !menu";
          bindings = {
            "ctrl-w" = "pane::CloseActiveItem";
          };
        }
        {
          context = "vim_mode == normal || vim_mode == visual";
          bindings = {
            "shift-h" = "pane::ActivatePreviousItem";
            "shift-l" = "pane::ActivateNextItem";
          };
        }
      ];
    };
  };
}
