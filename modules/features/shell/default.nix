{...}: {
  flake.modules.nixos.features.shell = {
    imports = [
      ./bash.nix
      ./zsh.nix
    ];
  };

  flake.modules.homeManager.features.shell = {
    imports = [
      ./bash.nix
      ./zsh.nix
    ];
  };
}
