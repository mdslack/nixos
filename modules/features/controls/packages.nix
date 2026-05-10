_: {
  flake.modules.nixos.controls-packages =
    { pkgs, ... }:
    {
      users.users.mslack.extraGroups = [ "video" ];

      environment.systemPackages = with pkgs; [
        bluetui
        impala
        v4l-utils
        wiremix
      ];
    };
}
