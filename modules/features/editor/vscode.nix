{pkgs, ...}: {
  flake.modules.nixos.editor-vscode = {
    environment.systemPackages = [
      pkgs.vscode
    ];
  };
}
