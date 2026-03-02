{config, ...}: {
  flake.modules.nixos.minimal = {
    imports = [
      config.flake.modules.nixos.features.ai
      config.flake.modules.nixos.features.files
      config.flake.modules.nixos.features.network
      config.flake.modules.nixos.features.theme
      config.flake.modules.nixos.features.shell
      config.flake.modules.nixos.features.terminal
      config.flake.modules.nixos.features.input
      config.flake.modules.nixos.features.vpn
      config.flake.modules.nixos.users.mslack
    ];
  };
}
