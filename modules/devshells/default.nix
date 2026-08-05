_: {
  perSystem =
    {
      config,
      ...
    }:
    let
      inherit (config._module.args) pkgs;
      inherit (config.dev) shellSets;
      packagesFor = names: builtins.concatLists (map (name: shellSets.${name} or [ ]) names);
      shellProfiles = {
        baseline = packagesFor [ "base" ];
        go = packagesFor [
          "base"
          "go"
          "doppler"
        ];
        rust = packagesFor [
          "base"
          "rust"
          "doppler"
        ];
        python = packagesFor [
          "base"
          "python"
          "doppler"
        ];
        web = packagesFor [
          "base"
          "node"
          "doppler"
        ];
        docs = packagesFor [
          "base"
          "docs"
        ];
        nix = packagesFor [
          "base"
          "nix"
        ];
        proto = packagesFor [
          "base"
          "protobuf"
          "doppler"
        ];
        full = packagesFor [
          "base"
          "monitoring"
          "go"
          "rust"
          "python"
          "node"
          "dotnet"
          "protobuf"
          "docs"
          "nix"
          "devenv"
          "doppler"
        ];
      };
      nativePythonRuntimeLibs = with pkgs; [
        stdenv.cc.cc.lib
        fontconfig
        libglvnd
        libGLU
        mesa
        vulkan-loader
        wayland
        libxkbcommon
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXfixes
        xorg.libXft
        xorg.libXinerama
        xorg.libXrender
        zlib
      ];
      nativePythonRuntimeShellHook = ''
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath nativePythonRuntimeLibs}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
      '';
      zshShellHook = ''
        if [ "''${TERM:-dumb}" = "dumb" ]; then
          export TERM=xterm-256color
        fi

        if [[ $- == *i* ]] && [ -z "''${ZSH_VERSION:-}" ]; then
          exec ${pkgs.zsh}/bin/zsh -l
        fi
      '';
      mkDevShell =
        shellName: attrs:
        pkgs.mkShell (
          attrs
          // {
            shellHook = ''
              export NIX_DEVSHELL_NAME="${shellName}"
            ''
            + (attrs.shellHook or "")
            + zshShellHook;
          }
        );
    in
    {
      dev.shellProfiles = shellProfiles;

      devShells = {
        default = mkDevShell "default" {
          packages = shellProfiles.baseline;
        };

        go = mkDevShell "go" {
          packages = shellProfiles.go;
        };

        rust = mkDevShell "rust" {
          packages = shellProfiles.rust;
          shellHook = nativePythonRuntimeShellHook;
        };

        python = mkDevShell "python" {
          packages = shellProfiles.python;
          shellHook = nativePythonRuntimeShellHook;
        };

        web = mkDevShell "web" {
          packages = shellProfiles.web;
        };

        docs = mkDevShell "docs" {
          packages = shellProfiles.docs;
          MARKDOWNLINT_CONFIG = ./config/markdownlint.yaml;
        };

        nix = mkDevShell "nix" {
          packages = shellProfiles.nix;
        };

        proto = mkDevShell "proto" {
          packages = shellProfiles.proto;
        };

        full = mkDevShell "full" {
          packages = shellProfiles.full;
          MARKDOWNLINT_CONFIG = ./config/markdownlint.yaml;
          shellHook = nativePythonRuntimeShellHook;
        };
      };
    };
}
