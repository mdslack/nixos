{ config, lib, pkgs, username, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
  yaziCatppuccinMocha = pkgs.callPackage ../packages/yazi-flavors/catppuccin-mocha.nix { };

  managedXdgEntries = {
    "DankMaterialShell" = { source = "dms/.config/DankMaterialShell"; recursive = true; };
    "nvim" = { source = "lazyvim/.config/nvim"; recursive = true; };
    "zed" = { source = "zed/.config/zed"; recursive = true; };
    "markdown" = { source = "markdown/.config/markdown"; recursive = true; };
  };

  managedHomeEntries = {
    ".zshrc" = { source = "zsh/.zshrc"; };
    ".bashrc" = { source = "bash/.bashrc"; };
    ".gitconfig" = { source = "git/.gitconfig"; };
    ".ssh/config" = { source = "ssh/.ssh/config"; };
    ".opencode/opencode.jsonc" = { source = "opencode/.opencode/opencode.jsonc"; };
  };
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
  ];

  programs.yazi = {
    enable = true;
    flavors = {
      catppuccin-mocha = yaziCatppuccinMocha;
    };
    theme = {
      flavor = {
        dark = "catppuccin-mocha";
        light = "catppuccin-mocha";
      };
    };
  };

  xdg.configFile = builtins.listToAttrs (
    map (name:
      let
        entry = managedXdgEntries.${name};
      in {
        name = name;
        value = {
          source = mkOutOfStoreSymlink "${dotfilesRoot}/${entry.source}";
          recursive = entry.recursive or false;
          force = true;
        };
      })
    (builtins.attrNames managedXdgEntries)
  );

  home.file =
    {
      ".oh-my-zsh".source = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
      ".local/bin/protonvpn-status" = {
        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          if command -v protonvpn-cli >/dev/null 2>&1; then
            exec protonvpn-cli status
          fi

          nmcli -t -f NAME,TYPE,DEVICE connection show --active | awk -F: '$2 == "vpn" || tolower($1) ~ /proton/'
        '';
        executable = true;
      };
      ".local/bin/protonvpn-up" = {
        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          if command -v protonvpn-cli >/dev/null 2>&1; then
            if [[ $# -gt 0 ]]; then
              exec protonvpn-cli connect --cc "$1"
            fi
            exec protonvpn-cli connect
          fi

          if [[ $# -gt 0 ]]; then
            exec nmcli connection up id "$1"
          fi

          conn="$(nmcli -t -f NAME,TYPE connection show | awk -F: 'tolower($1) ~ /proton/ && $2 == "vpn" { print $1; exit }')"
          if [[ -z "$conn" ]]; then
            printf 'No Proton VPN connection profile found. Open protonvpn-app first.\n' >&2
            exit 1
          fi

          exec nmcli connection up id "$conn"
        '';
        executable = true;
      };
      ".local/bin/protonvpn-down" = {
        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          if command -v protonvpn-cli >/dev/null 2>&1; then
            exec protonvpn-cli disconnect
          fi

          if [[ $# -gt 0 ]]; then
            exec nmcli connection down id "$1"
          fi

          conn="$(nmcli -t -f NAME,TYPE connection show --active | awk -F: 'tolower($1) ~ /proton/ && ($2 == "vpn" || $2 == "wireguard") { print $1; exit }')"
          if [[ -z "$conn" ]]; then
            printf 'No active Proton VPN connection found.\n' >&2
            exit 0
          fi

          exec nmcli connection down id "$conn"
        '';
        executable = true;
      };
    }
    // builtins.listToAttrs (
      map (name:
        let
          entry = managedHomeEntries.${name};
        in {
          name = name;
          value = {
            source = mkOutOfStoreSymlink "${dotfilesRoot}/${entry.source}";
            recursive = entry.recursive or false;
            force = true;
          };
        })
      (builtins.attrNames managedHomeEntries)
    );

  home.activation.installOhMyZshPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ZSH_CUSTOM="${config.home.homeDirectory}/.oh-my-zsh-custom"
    mkdir -p "$ZSH_CUSTOM/plugins"

    if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" || true
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete" || true
    fi
  '';

}
