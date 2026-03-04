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
      zshShellHook = ''
        if [ "''${TERM:-dumb}" = "dumb" ]; then
          export TERM=xterm-256color
        fi

        if [[ $- == *i* ]] && [ -z "''${ZSH_VERSION:-}" ]; then
          exec ${pkgs.zsh}/bin/zsh -l
        fi
      '';
      mkDevShell = shellName: attrs:
        pkgs.mkShell (
          attrs
          // {
            shellHook = ''
              export NIX_DEVSHELL_NAME="${shellName}"
            '' + (attrs.shellHook or "") + zshShellHook;
          }
        );
    in
    {
      devShells = {
        default = mkDevShell "default" {
          packages = packagesFor [ "base" ];
        };

        go = mkDevShell "go" {
          packages = packagesFor [
            "base"
            "go"
            "doppler"
          ];
        };

        rust = mkDevShell "rust" {
          packages = packagesFor [
            "base"
            "rust"
            "doppler"
          ];
        };

        python = mkDevShell "python" {
          packages = packagesFor [
            "base"
            "python"
            "doppler"
          ];
        };

        web = mkDevShell "web" {
          packages = packagesFor [
            "base"
            "node"
            "doppler"
          ];
        };

        docs = mkDevShell "docs" {
          packages = packagesFor [
            "base"
            "docs"
          ];
          MARKDOWNLINT_CONFIG = ./config/markdownlint.yaml;
        };

        nix = mkDevShell "nix" {
          packages = packagesFor [
            "base"
            "nix"
          ];
        };

        proto = mkDevShell "proto" {
          packages = packagesFor [
            "base"
            "protobuf"
            "doppler"
          ];
        };

        full = mkDevShell "full" {
          packages = packagesFor [
            "base"
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
          MARKDOWNLINT_CONFIG = ./config/markdownlint.yaml;
        };
      };
    };
}
