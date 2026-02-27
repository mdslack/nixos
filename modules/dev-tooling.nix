{ lib, pkgs, username, config, ... }:
let
  cfg = config.workstation.devTooling;
in {
  options.workstation.devTooling = {
    enableVmManager = lib.mkEnableOption "libvirt and virt-manager stack";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [
        doppler
        git-lfs
        lazygit
        fd
        fzf
        ripgrep
        pandoc
        go
        gopls
        nodejs
        dotnet-sdk
        python3
        uv
        mermaid-cli
        protobuf
        rustup
        mdbook
      ];
    }
    {
      environment.systemPackages = [ pkgs.texlive.combined.scheme-medium ];
    }
    {
      environment.systemPackages =
        (lib.optionals (builtins.hasAttr "opencode" pkgs) [ pkgs.opencode ])
        ++ (lib.optionals (builtins.hasAttr "codex" pkgs) [ pkgs.codex ])
        ++ (lib.optionals (builtins.hasAttr "claude-code" pkgs) [ pkgs."claude-code" ]);
    }
    (lib.mkIf cfg.enableVmManager {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      users.users.${username}.extraGroups = [ "libvirtd" ];
    })
  ];
}
