_: {
  flake.modules.nixos.controls =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bluetui
        impala
        wiremix
      ];
    };
}
