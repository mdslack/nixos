{ lib, pkgs, username, config, ... }:
let
  cfg = config.workstation.devTooling;
in {
  options.workstation.devTooling = {
    enable = lib.mkEnableOption "workstation dev tooling";
    enableVmManager = lib.mkEnableOption "libvirt and virt-manager stack";
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
    (lib.mkIf cfg.enableVmManager {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;
      users.users.${username}.extraGroups = [ "libvirtd" ];
    })
  ]);
}
