{config, ...}: {
  flake.modules.nixos.virtualization = {
    imports = [
      config.flake.modules.nixos.virtualization-containers
      config.flake.modules.nixos.virtualization-vm
    ];
  };

  flake.modules.homeManager.virtualization = {
    imports = [
      config.flake.modules.homeManager.virtualization-containers
    ];
  };
}
