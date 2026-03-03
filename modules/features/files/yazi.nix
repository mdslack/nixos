_: {
  flake.modules.nixos.files-yazi =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.yazi
      ];
    };

  flake.modules.homeManager.files-yazi =
    { pkgs, ... }:
    let
      yaziCatppuccinMocha = pkgs.stdenvNoCC.mkDerivation {
        pname = "yazi-flavor-catppuccin-mocha";
        version = "2026-01-18";

        src = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "flavors";
          rev = "ca6165818bb84d46af5fd8f95bedd2b1c395890a";
          hash = "sha256-xGnebGuSOZpQl/QhuZkwgrjfAlfbEtruA9UVe030mZM=";
        };

        installPhase = ''
          mkdir -p "$out"
          cp "$src/catppuccin-mocha.yazi"/* "$out/"
        '';
      };
    in
    {
      programs.yazi = {
        enable = true;
        shellWrapperName = "yy";
        flavors = {
          catppuccin-mocha = yaziCatppuccinMocha;
        };
        theme = {
          flavor = {
            dark = "catppuccin-mocha";
            light = "catppuccin-mocha";
          };
        };
      };
    };
}
