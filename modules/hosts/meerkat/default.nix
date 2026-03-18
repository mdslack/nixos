{
  config,
  lib,
  ...
}: let
  M = name: config.flake.modules.nixos.${name} or {};
  modes = lib.mapAttrs (_: featureNames: map M featureNames) config.flake.meta.hostModes;
  hostFeatures =
    [
      config.flake.modules.nixos.graphics-amd
    ]
    ++ lib.optionals (config.flake.meta.hostToggles.meerkat.egpu or false) [
      config.flake.modules.nixos.graphics-egpu
    ];
in {
  flake.modules.nixos =
    lib.mapAttrs' (
      modeName: modeImports:
        lib.nameValuePair "hosts/meerkat/${modeName}" {
          imports = modeImports ++ hostFeatures;
          networking.hostName = "meerkat";
          facter.reportPath = ./facter.json;

          boot.loader.systemd-boot.enable = lib.mkDefault true;
          boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

          boot.initrd.availableKernelModules = [
            "xhci_pci"
            "thunderbolt"
            "nvme"
            "usb_storage"
            "usbhid"
            "sd_mod"
          ];
          boot.initrd.kernelModules = [];
          boot.kernelModules = ["kvm-intel"];
          boot.extraModulePackages = [];

          fileSystems."/" = lib.mkDefault {
            device = "/dev/disk/by-label/nixos";
            fsType = "ext4";
          };

          fileSystems."/boot" = lib.mkDefault {
            device = "/dev/disk/by-label/boot";
            fsType = "vfat";
            options = [
              "fmask=0022"
              "dmask=0022"
            ];
          };

          swapDevices = lib.mkDefault [
            {device = "/dev/disk/by-label/swap";}
          ];

          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
        }
    )
    modes;
}
