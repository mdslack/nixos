{config, lib, ...}: let
  M = name: lib.attrByPath (lib.splitString "." name) {} config.flake.modules.nixos;
  modes = lib.mapAttrs (_: featureNames: map M featureNames) config.flake.meta.hostModes;
  hostFeatures = [
    config.flake.modules.nixos.features.graphics.amd
  ] ++ lib.optionals (config.flake.meta.hostToggles.framework13.egpu or false) [
    config.flake.modules.nixos.features.graphics.egpu
  ];
in {
  flake.modules.nixos = lib.mapAttrs' (modeName: modeImports:
    lib.nameValuePair "hosts/framework13/${modeName}" {
      imports = modeImports ++ hostFeatures;
      networking.hostName = "framework13";
      facter.reportPath = ./facter.json;
      services.fprintd.enable = true;

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
