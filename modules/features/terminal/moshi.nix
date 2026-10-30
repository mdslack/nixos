_:
let
  mkMoshi = pkgs: pkgs.callPackage ../../../packages/moshi-hook.nix { };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.moshi-hook = mkMoshi pkgs;
    };

  flake.modules.homeManager.terminal-moshi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      moshi = mkMoshi pkgs;
    in
    {
      nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "moshi-hook";
      home.packages = [ moshi ];

      # Moshi probes these paths before the login shell's PATH. Also keep
      # existing agent hooks pointing at the Nix-managed version after upgrades.
      home.file = {
        ".local/bin/moshi-hook" = {
          source = "${moshi}/bin/moshi-hook";
          force = true;
        };
        ".local/bin/moshi" = {
          source = "${moshi}/bin/moshi";
          force = true;
        };
      };

      xdg.configFile."moshi/config.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/moshi/config.toml";
      };

      systemd.user.services.moshi-hook = {
        Unit = {
          Description = "Moshi agent hook daemon";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          ExecStart = "${moshi}/bin/moshi-hook serve";
          Restart = "on-failure";
          RestartSec = 5;
          Environment = "PATH=%h/.nix-profile/bin:/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
}
