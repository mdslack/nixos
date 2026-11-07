{ inputs, ... }:
let
  mkVoxtype =
    pkgs:
    let
      package = inputs.nixpkgs-apps.legacyPackages.${pkgs.stdenv.hostPlatform.system}.voxtype.override {
        vulkanSupport = true;
      };
    in
    pkgs.symlinkJoin {
      name = "voxtype-${package.version}";
      paths = [ package ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      # This app uses a newer nixpkgs than the session's native-library path.
      postBuild = ''
        wrapProgram $out/bin/voxtype --unset LD_LIBRARY_PATH
      '';
      meta = package.meta;
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.voxtype = mkVoxtype pkgs;
    };

  flake.modules.homeManager.input-voxtype =
    { config, pkgs, ... }:
    let
      voxtype = mkVoxtype pkgs;
    in
    {
      home.packages = [ voxtype ];

      # A stable path for compositor shortcuts, including before the session's
      # profile PATH has refreshed after an upgrade.
      home.file.".local/bin/voxtype".source = "${voxtype}/bin/voxtype";

      xdg.configFile."voxtype/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/voxtype/config.toml";

      systemd.user.services.voxtype = {
        Unit = {
          Description = "Voxtype offline voice dictation";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${voxtype}/bin/voxtype daemon";
          Restart = "on-failure";
          RestartSec = 5;
          Environment = "PATH=${
            pkgs.lib.makeBinPath [
              voxtype
              pkgs.wtype
              pkgs.wl-clipboard
              pkgs.libnotify
            ]
          }:/run/current-system/sw/bin";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
