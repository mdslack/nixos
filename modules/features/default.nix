_: {
  flake.modules.nixos.controls =
    { pkgs, ... }:
    {
      networking.networkmanager.wifi.backend = "iwd";
      networking.wireless.iwd.enable = true;

      environment.systemPackages = with pkgs; [
        bluetui
        impala
        wiremix
      ];
    };
}
