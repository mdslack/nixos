{ inputs, ... }:
{
  flake.modules.nixos.session-noctalia =
    { pkgs, ... }:
    {
      imports = [
        inputs.noctalia.nixosModules.default
      ];

      environment.systemPackages = [
        pkgs.adwaita-icon-theme
        pkgs.hicolor-icon-theme
        pkgs.papirus-icon-theme
      ];
    };

  flake.modules.homeManager.session-noctalia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        # The session's native-library path contains stable libstdc++, while
        # Noctalia is built against unstable. Use its own runtime dependencies.
        package = pkgs.symlinkJoin {
          name = "noctalia-wrapped";
          paths = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/noctalia --unset LD_LIBRARY_PATH
          '';
          meta.mainProgram = "noctalia";
        };
        settings = lib.mkForce { };
      };

      xdg.configFile."noctalia" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia";
        recursive = true;
      };

      home.file.".local/share/sounds/noctalia-classic/index.theme".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia/sounds/noctalia-classic/index.theme";
      home.file.".local/share/sounds/noctalia-classic/stereo/message-new-instant.wav".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia/sounds/noctalia-classic/stereo/message-new-instant.wav";
    };
}
