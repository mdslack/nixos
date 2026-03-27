_: {
  flake.modules.nixos.bundle-hardware-laptop =
    {pkgs, ...}: {
      services.upower.enable = true;

      environment.systemPackages = [
        pkgs.upower
      ];
    };
}
