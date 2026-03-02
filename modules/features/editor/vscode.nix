{pkgs, ...}: {
  flake.modules.nixos.features.editor.vscode = {
    environment.systemPackages = [
      pkgs.vscode
    ];
  };
}
