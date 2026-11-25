{ inputs, ... }:
{
  flake.modules.nixos.vpn-proton =
    { pkgs, ... }:
    let
      appPkgs = import inputs.nixpkgs-app-updates {
        system = pkgs.stdenv.hostPlatform.system;
      };
      protonVpn = appPkgs.proton-vpn.overrideAttrs (
        finalAttrs: previousAttrs: {
          version = "4.19.1";
          src = appPkgs.fetchFromGitHub {
            owner = "ProtonVPN";
            repo = "proton-vpn-gtk-app";
            tag = "v${finalAttrs.version}";
            hash = "sha256-9ROVI69ykbmc/o4X8T1wC0H9ij/6Vi+MN1/0leAbljU=";
          };
          # The session exports libraries from the older system package set.
          # Let Proton's Python and GTK use their own matching dependencies.
          makeWrapperArgs = (previousAttrs.makeWrapperArgs or [ ]) ++ [
            "--unset"
            "LD_LIBRARY_PATH"
          ];
        }
      );
    in
    {
      environment.systemPackages = [
        protonVpn
      ];
    };
}
