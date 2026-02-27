{ lib, pkgs, username, config, ... }:
let
  cfg = config.workstation.devTooling;
in {
  options.workstation.devTooling = {
    enable = lib.mkEnableOption "workstation dev tooling";
    enableVmManager = lib.mkEnableOption "libvirt and virt-manager stack";
    enableTexLive = lib.mkEnableOption "TeX Live toolchain";
    enableAiCli = lib.mkEnableOption "OpenCode, Codex, and Claude CLI tools";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [
        git-lfs
        lazygit
        fd
        fzf
        ripgrep
        pandoc
        nodejs
        mermaid-cli
        protobuf
        rustup
        mdbook
      ];
    }
    (lib.mkIf cfg.enableTexLive {
      environment.systemPackages = [ pkgs.texlive.combined.scheme-medium ];
    })
    (lib.mkIf cfg.enableAiCli {
      environment.systemPackages =
        (lib.optionals (builtins.hasAttr "opencode" pkgs) [ pkgs.opencode ])
        ++ (lib.optionals (builtins.hasAttr "codex" pkgs) [ pkgs.codex ])
        ++ (lib.optionals (builtins.hasAttr "claude-code" pkgs) [ pkgs."claude-code" ]);

      warnings =
        (lib.optionals (!(builtins.hasAttr "opencode" pkgs)) [
          "workstation.devTooling.enableAiCli is true, but pkgs.opencode is unavailable in this nixpkgs revision."
        ])
        ++ (lib.optionals (!(builtins.hasAttr "codex" pkgs)) [
          "workstation.devTooling.enableAiCli is true, but pkgs.codex is unavailable in this nixpkgs revision."
        ])
        ++ (lib.optionals (!(builtins.hasAttr "claude-code" pkgs)) [
          "workstation.devTooling.enableAiCli is true, but pkgs.claude-code is unavailable in this nixpkgs revision."
        ]);
    })
    (lib.mkIf cfg.enableVmManager {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      users.users.${username}.extraGroups = [ "libvirtd" ];
    })
  ]);
}
