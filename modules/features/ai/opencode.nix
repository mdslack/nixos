_: {
  flake.modules.nixos.ai-opencode =
    { inputs, lib, pkgs, ... }:
    let
      bunForBuild =
        if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
          pkgs.stdenvNoCC.mkDerivation {
            pname = "bun";
            version = "1.3.10";

            src = pkgs.fetchurl {
              url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.10/bun-linux-x64.zip";
              hash = "sha256-9XvAGH45Yj3nFro6OJ/aVIay175xMamAulTce3M9Lgg=";
            };

            nativeBuildInputs = [
              pkgs.unzip
              pkgs.installShellFiles
              pkgs.makeWrapper
            ] ++ lib.optionals pkgs.stdenvNoCC.hostPlatform.isLinux [ pkgs.autoPatchelfHook ];

            buildInputs = [ pkgs.openssl ];

            dontConfigure = true;
            dontBuild = true;

            installPhase = ''
              runHook preInstall

              install -Dm755 ./bun $out/bin/bun
              ln -s $out/bin/bun $out/bin/bunx

              runHook postInstall
            '';

            meta = {
              description = "Bun JavaScript runtime";
              homepage = "https://bun.sh";
              mainProgram = "bun";
              platforms = [ "x86_64-linux" ];
            };
          }
        else
          pkgs.bun;
      opencodeHashes = builtins.fromJSON (builtins.readFile "${inputs.opencode-src}/nix/hashes.json");
      opencodeNodeModules = pkgs.callPackage "${inputs.opencode-src}/nix/node_modules.nix" {
        bun = bunForBuild;
        rev = inputs.opencode-src.rev;
        hash = opencodeHashes.nodeModules.${pkgs.stdenv.hostPlatform.system};
      };
      opencodeLatest = pkgs.callPackage "${inputs.opencode-src}/nix/opencode.nix" {
        bun = bunForBuild;
        node_modules = opencodeNodeModules;
      };
    in
    {
      environment.systemPackages = [
        opencodeLatest
      ];
    };

  flake.modules.homeManager.ai-opencode = {
    home.file.".opencode/opencode.jsonc".text = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "keybinds": {
          "variant_cycle": "ctrl+tab"
        }
      }
    '';
  };
}
