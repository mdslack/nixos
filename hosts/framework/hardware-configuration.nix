{ lib, ... }:
{
  # Replace this file with output from:
  #   sudo nixos-generate-config --show-hardware-config > hosts/framework/hardware-configuration.nix

  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
}
