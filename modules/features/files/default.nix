{...}: {
  flake.modules.nixos.features.files = {
    imports = [
      ./yazi.nix
    ];
  };

  flake.modules.homeManager.features.files = {
    imports = [
      ./yazi.nix
    ];
  };
}
