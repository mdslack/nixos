{ inputs, ... }:
{
  flake.modules.nixos.files-luciole =
    { pkgs, ... }:
    let
      upstream = inputs.luciole.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      imports = [ inputs.luciole.nixosModules.default ];

      programs.luciole.enable = true;
      # Luciole is built against unstable; keep the session's stable
      # native-library path from shadowing its own runtime dependencies.
      programs.luciole.package = pkgs.symlinkJoin {
        name = "luciole-${upstream.version}";
        paths = [ upstream ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/luciole --unset LD_LIBRARY_PATH
        '';
        inherit (upstream) meta;
      };

      # Trash and remote folders rely on services.gvfs (enabled in base).
      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };

  flake.modules.homeManager.files-luciole =
    { config, ... }:
    {
      # Link the whole directory so the GUI-written settings.toml and
      # Noctalia's colors.toml are tracked in dotfiles alongside config.toml.
      xdg.configFile."luciole".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/luciole";
    };
}
