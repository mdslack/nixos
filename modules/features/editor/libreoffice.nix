_: {
  # Included in default editor baseline.
  flake.modules.nixos.editor-libreoffice = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libreoffice
    ];
  };
}
