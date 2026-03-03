{ config, lib, ... }:
let
  M = name: config.flake.modules.nixos.${name} or { };
  modes = lib.mapAttrs (_: featureNames: map M featureNames) config.flake.meta.hostModes;
  hostFeatures = [
    config.flake.modules.nixos.graphics-amd
  ]
  ++ lib.optionals (config.flake.meta.hostToggles.framework13.egpu or false) [
    config.flake.modules.nixos.graphics-egpu
  ];
in
{
  flake.modules.nixos = lib.mapAttrs' (
    modeName: modeImports:
    lib.nameValuePair "hosts/framework13/${modeName}" {
      imports = modeImports ++ hostFeatures;
      networking.hostName = "framework13";
      facter.reportPath = ./facter.json;
      services.fprintd.enable = true;

      boot.loader.systemd-boot.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

      fileSystems."/" = lib.mkDefault {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };

      fileSystems."/boot" = lib.mkDefault {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
      };
    }
  ) modes;
}
