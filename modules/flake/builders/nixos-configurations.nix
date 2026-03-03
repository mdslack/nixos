{
  config,
  inputs,
  lib,
  ...
}:
let
  prefix = "hosts/";

  hostLeaves = lib.filterAttrs (name: _: lib.hasPrefix prefix name) config.flake.modules.nixos;

  parseLeaf =
    name:
    let
      suffix = lib.removePrefix prefix name;
      parts = lib.splitString "/" suffix;
    in
    {
      host = builtins.elemAt parts 0;
      mode = builtins.elemAt parts 1;
    };

  mkConfig =
    leafName: leafModule:
    let
      parsed = parseLeaf leafName;
      hostName = parsed.host;
      modeName = parsed.mode;
      outputName = "${hostName}-${modeName}";
      system = "x86_64-linux";

      facterModule =
        if builtins.hasAttr "facter" inputs.nixos-facter-modules.nixosModules then
          inputs.nixos-facter-modules.nixosModules.facter
        else
          null;

      specialArgs = {
        inherit hostName inputs;
        pkgsUnstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    lib.nameValuePair outputName (
      inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs system;
        modules = [
          config.flake.modules.nixos.base
          leafModule
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.backupFileExtension = "hm-bak";
            home-manager.sharedModules = [ config.flake.modules.homeManager.base ];
          }
        ]
        ++ lib.optional (facterModule != null) facterModule;
      }
    );
in
{
  flake.nixosConfigurations = lib.mapAttrs' mkConfig hostLeaves;
}
