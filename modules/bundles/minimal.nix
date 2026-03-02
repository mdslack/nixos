{config, ...}: {
  flake.modules.nixos.minimal = {
    imports = [
      config.flake.modules.nixos.ai
      config.flake.modules.nixos.files
      config.flake.modules.nixos.network
      config.flake.modules.nixos.security
      config.flake.modules.nixos.virtualization
      config.flake.modules.nixos.shell
      config.flake.modules.nixos.terminal
      config.flake.modules.nixos.input
      config.flake.modules.nixos.vpn
      config.flake.modules.nixos.users-mslack
    ];
  };
}
