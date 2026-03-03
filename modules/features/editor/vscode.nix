_: {
  flake.modules.nixos.editor-vscode =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.vscode
      ];
    };
}
