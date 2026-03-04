{ inputs, ... }:
{
  imports = [
    ../devshells/options.nix
    ../devshells/default.nix
    ../devshells/sets/base.nix
    ../devshells/sets/go.nix
    ../devshells/sets/protobuf.nix
    ../devshells/sets/rust.nix
    ../devshells/sets/python.nix
    ../devshells/sets/node.nix
    ../devshells/sets/dotnet.nix
    ../devshells/sets/docs.nix
    ../devshells/sets/nix.nix
    ../devshells/sets/secrets/doppler.nix
    ../devshells/sets/tools/devenv.nix
  ];

  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.rust-overlay.overlays.default
        ];
      };

      _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.rust-overlay.overlays.default
        ];
      };
    };
}
