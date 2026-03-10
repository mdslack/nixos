_: {
  # Included in default editor baseline.
  flake.modules.nixos.editor-neovim = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      xclip
    ];
  };
}
