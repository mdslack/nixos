_: {
  flake.modules.nixos.graphics-amd =
    { pkgs, ... }:
    {
      hardware.enableRedistributableFirmware = true;
      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;
      hardware.graphics.extraPackages = with pkgs; [
        mesa
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
}
