{pkgs, ...}: {
  flake.modules.nixos.features.vpn.proton = {
    environment.systemPackages = [
      pkgs.protonvpn-gui
      pkgs."proton-vpn-cli"
    ];
  };
}
