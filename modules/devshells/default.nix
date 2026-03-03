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
    in
    {
      devShells = {
        default = pkgs.mkShell {
          packages = packagesFor [ "base" ];
        };

        go = pkgs.mkShell {
          packages = packagesFor [
            "base"
            "go"
            "doppler"
          ];
        };

        rust = pkgs.mkShell {
          packages = packagesFor [
            "base"
            "rust"
            "doppler"
          ];
        };

        python = pkgs.mkShell {
          packages = packagesFor [
            "base"
            "python"
            "doppler"
          ];
        };

        web = pkgs.mkShell {
          packages = packagesFor [
            "base"
            "node"
            "doppler"
          ];
        };

        docs = pkgs.mkShell {
          packages = packagesFor [
            "base"
            "docs"
          ];
          MARKDOWNLINT_CONFIG = ./config/markdownlint.yaml;
        };

        nix = pkgs.mkShell {
          packages = packagesFor [
            "base"
            "nix"
          ];
        };

        proto = pkgs.mkShell {
          packages = packagesFor [
            "base"
            "protobuf"
            "doppler"
          ];
        };

        full = pkgs.mkShell {
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
