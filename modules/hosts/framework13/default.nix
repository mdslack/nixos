{
  config,
  lib,
  ...
}: let
  M = name: config.flake.modules.nixos.${name} or {};
  modes = lib.mapAttrs (_: featureNames: map M featureNames) config.flake.meta.hostModes;
  hostFeatures =
    [
      config.flake.modules.nixos.bundle-hardware-laptop
      config.flake.modules.nixos.graphics-amd
      config.flake.modules.nixos.monitoring-victoriametrics
    ]
    ++ lib.optionals (config.flake.meta.hostToggles.framework13.egpu or false) [
      config.flake.modules.nixos.graphics-egpu
    ];
in {
  flake.modules.nixos =
    lib.mapAttrs' (
      modeName: modeImports:
        lib.nameValuePair "hosts/framework13/${modeName}" {
          imports = modeImports ++ hostFeatures;
          networking.hostName = "framework13";
          facter.reportPath = ./facter.json;
          services.fprintd.enable = true;

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
          boot.kernelModules = ["kvm-amd"];
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
          hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
        }
    )
    modes;
}
