{config, pkgs, ...}: {
  flake.modules.nixos.features.graphics.nvidia = {
    hardware.enableRedistributableFirmware = true;
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages = with pkgs; [
      mesa
      libva-vdpau-driver
      libvdpau-va-gl
    ];

    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
