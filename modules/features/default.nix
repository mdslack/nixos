{ config, lib, ... }:
let
  hostToggles = config.flake.meta.hostToggles;
in
{
  flake.modules.nixos.development-tools =
    {
      devShellProfiles,
      devNativeRuntimeLibs,
      hostName,
      pkgs,
      ...
    }:
    let
      profileFlags = hostToggles.${hostName}.permanentDevShells or { };
      invalidFlags = lib.filterAttrs (_: enabled: !builtins.isBool enabled) profileFlags;
      unknownProfiles = lib.filterAttrs (name: _: !(builtins.hasAttr name devShellProfiles)) profileFlags;
      enabledProfiles = builtins.attrNames (lib.filterAttrs (_: enabled: enabled == true) profileFlags);
      hasDevTools = enabledProfiles != [ ];
      hasNativeRuntime = builtins.any (name: builtins.elem name enabledProfiles) [
        "rust"
        "python"
        "full"
      ];
      profilePackages = lib.unique (
        builtins.concatLists (map (name: devShellProfiles.${name}) enabledProfiles)
      );
      nativeLibraries = lib.optionals hasNativeRuntime devNativeRuntimeLibs;
      developmentPackages = profilePackages ++ nativeLibraries;
      # Include propagated dependencies such as X11 protocol headers when
      # resolving Requires entries in the libraries' pkg-config files.
      pkgConfigPackages = lib.closePropagation developmentPackages;
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

      # mkShell supplies a compiler and development outputs implicitly. System
      # packages need these explicitly, along with the pkg-config search path.
      environment.systemPackages =
        developmentPackages
        ++ map lib.getDev developmentPackages
        ++ lib.optionals hasDevTools [ pkgs.stdenv.cc ];

      environment.sessionVariables = lib.mkMerge [
        (lib.mkIf hasDevTools {
          PKG_CONFIG_PATH = [
            (lib.makeSearchPathOutput "dev" "lib/pkgconfig" pkgConfigPackages)
            (lib.makeSearchPathOutput "dev" "share/pkgconfig" pkgConfigPackages)
          ];
        })
        (lib.mkIf hasNativeRuntime {
          LD_LIBRARY_PATH = [ (lib.makeLibraryPath nativeLibraries) ];
        })
      ];
    };
}
