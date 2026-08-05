{ config, lib, ... }:
let
  hostToggles = config.flake.meta.hostToggles;
in
{
  flake.modules.nixos.development-tools =
    {
      devShellProfiles,
      hostName,
      ...
    }:
    let
      profileFlags = hostToggles.${hostName}.permanentDevShells or { };
      invalidFlags = lib.filterAttrs (_: enabled: !builtins.isBool enabled) profileFlags;
      unknownProfiles = lib.filterAttrs (name: _: !(builtins.hasAttr name devShellProfiles)) profileFlags;
      enabledProfiles = builtins.attrNames (lib.filterAttrs (_: enabled: enabled == true) profileFlags);
    in
    {
      assertions = [
        {
          assertion = invalidFlags == { };
          message = "Development-shell profile flags must be boolean values.";
        }
        {
          assertion = unknownProfiles == { };
          message = "Unknown development-shell profiles: ${builtins.concatStringsSep ", " (builtins.attrNames unknownProfiles)}";
        }
      ];

      environment.systemPackages = builtins.concatLists (
        map (name: devShellProfiles.${name}) enabledProfiles
      );
    };
}
