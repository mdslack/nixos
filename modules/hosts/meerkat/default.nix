{config, lib, ...}: let
  M = name: lib.attrByPath (lib.splitString "." name) {} config.flake.modules.nixos;
  modes = lib.mapAttrs (_: featureNames: map M featureNames) config.flake.meta.hostModes;
  hostFeatures = [
    config.flake.modules.nixos.features.graphics.amd
  ] ++ lib.optionals (config.flake.meta.hostToggles.meerkat.egpu or false) [
    config.flake.modules.nixos.features.graphics.egpu
  ];
in {
  flake.modules.nixos = lib.mapAttrs' (modeName: modeImports:
    lib.nameValuePair "hosts/meerkat/${modeName}" {
      imports = modeImports ++ hostFeatures;
      networking.hostName = "meerkat";
      facter.reportPath = ./facter.json;

      boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod"];
      boot.initrd.kernelModules = [];
      boot.kernelModules = ["kvm-intel"];
      boot.extraModulePackages = [];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/b1b8620b-5bc1-40dd-bbbd-63ec678ef5c5";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/748E-32C7";
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };

      swapDevices = [
        {device = "/dev/disk/by-uuid/b6bcd242-e1ee-4393-888d-5b874b711c8c";}
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    })
  modes;
}
