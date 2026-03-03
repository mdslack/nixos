{ config, lib, ... }:
let
  M = name: config.flake.modules.nixos.${name} or { };
  modes = lib.mapAttrs (_: featureNames: map M featureNames) config.flake.meta.hostModes;
  hostFeatures = [
    config.flake.modules.nixos.graphics-intel
  ]
  ++ lib.optionals (config.flake.meta.hostToggles.elitedesk.egpu or false) [
    config.flake.modules.nixos.graphics-egpu
  ];
in
{
  flake.modules.nixos = lib.mapAttrs' (
    modeName: modeImports:
    lib.nameValuePair "hosts/elitedesk/${modeName}" {
      imports = modeImports ++ hostFeatures;
      networking.hostName = "elitedesk";
      facter.reportPath = ./facter.json;

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
