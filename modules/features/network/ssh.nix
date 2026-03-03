_: {
  flake.modules.nixos.network-ssh =
    {
      config,
      lib,
      ...
    }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      networking.firewall = lib.mkIf config.services.tailscale.enable {
        trustedInterfaces = [ "tailscale0" ];
      };
    };
}
