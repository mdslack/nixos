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
      pkgConfigPath = builtins.concatStringsSep ":" [
        (lib.makeSearchPathOutput "dev" "lib/pkgconfig" pkgConfigPackages)
        (lib.makeSearchPathOutput "dev" "share/pkgconfig" pkgConfigPackages)
      ];
      nativeLibraryPath = lib.makeLibraryPath nativeLibraries;
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
            pkgConfigPath
          ];
        })
        (lib.mkIf hasNativeRuntime {
          LD_LIBRARY_PATH = [ nativeLibraryPath ];
        })
      ];

      # Persistent terminals can inherit the "environment already loaded"
      # marker while missing these variables. Restore the development paths
      # for each new shell, preserving additional paths without duplicating
      # our own prefix. Let explicit Nix development shells supply their own.
      environment.shellInit = lib.mkIf hasDevTools ''
        if [ -z "''${IN_NIX_SHELL-}" ]; then
          case ":''${PKG_CONFIG_PATH-}:" in
            *":${pkgConfigPath}:"*) ;;
            *) export PKG_CONFIG_PATH="${pkgConfigPath}''${PKG_CONFIG_PATH:+:}''${PKG_CONFIG_PATH-}" ;;
          esac
          ${lib.optionalString hasNativeRuntime ''
            case ":''${LD_LIBRARY_PATH-}:" in
              *":${nativeLibraryPath}:"*) ;;
              *) export LD_LIBRARY_PATH="${nativeLibraryPath}''${LD_LIBRARY_PATH:+:}''${LD_LIBRARY_PATH-}" ;;
            esac
          ''}
        fi
      '';
    };
}
