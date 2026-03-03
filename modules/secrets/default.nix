_: {
  flake.modules.nixos.secrets = {
    imports = [
      ./doppler.nix
    ];
  };
}
