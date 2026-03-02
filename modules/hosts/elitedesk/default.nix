{config, lib, ...}: let
  M = name: lib.attrByPath (lib.splitString "." name) {} config.flake.modules.nixos;
  modes = lib.mapAttrs (_: featureNames: map M featureNames) config.flake.meta.hostModes;
  hostFeatures = [
    config.flake.modules.nixos.features.graphics.intel
  ] ++ lib.optionals (config.flake.meta.hostToggles.elitedesk.egpu or false) [
    config.flake.modules.nixos.features.graphics.egpu
  ];
in {
  flake.modules.nixos = lib.mapAttrs' (modeName: modeImports:
    lib.nameValuePair "hosts/elitedesk/${modeName}" {
      imports = modeImports ++ hostFeatures;
      networking.hostName = "elitedesk";
      facter.reportPath = ./facter.json;

      fileSystems."/" = lib.mkDefault {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };

      fileSystems."/boot" = lib.mkDefault {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
      };
    })
  modes;
}
