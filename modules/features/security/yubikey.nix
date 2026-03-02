{...}: {
  flake.modules.nixos.security-yubikey = {pkgs, ...}: {
    services.pcscd.enable = true;
    hardware.gpgSmartcards.enable = true;

    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubico-piv-tool
      yubikey-personalization
    ];
  };
}
