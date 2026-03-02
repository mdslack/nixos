{pkgs, ...}: {
  flake.modules.nixos.features.graphics.amd = {
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
