_: {
  flake.modules.nixos.graphics-intel =
    { pkgs, ... }:
    {
      hardware.enableRedistributableFirmware = true;
      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;
      hardware.graphics.extraPackages = with pkgs; [
        mesa
        intel-media-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
}
