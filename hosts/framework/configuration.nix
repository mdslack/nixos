{ ... }:
{
  imports = [
    ../../modules/workstation-base.nix
    ./hardware-configuration.nix
  ];

  # Framework-specific: enable fingerprint support.
  services.fprintd.enable = true;
}
