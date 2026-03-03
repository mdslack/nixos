_: {
  flake.modules.nixos.vpn-proton =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.protonvpn-gui
      ];
    };
}
