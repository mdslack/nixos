_: {
  # Included in default editor baseline.
  flake.modules.nixos.editor-neovim = _: {
    # Empty because neovim is provided by nvf
    environment.systemPackages = [];
  };
}
