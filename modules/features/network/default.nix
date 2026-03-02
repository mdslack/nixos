{...}: {
  flake.modules.nixos.features.network = {
    imports = [
      ./firewall.nix
      ./ssh.nix
    ];

    networking.networkmanager.enable = true;
  };
}
