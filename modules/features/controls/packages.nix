_: {
  flake.modules.nixos.controls-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bluetui
        impala
        wiremix
      ];
    };
}
