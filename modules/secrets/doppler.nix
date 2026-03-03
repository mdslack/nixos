{
  config,
  lib,
  pkgs,
  ...
}:
{
  flake.modules.nixos.secrets-doppler = {
    options.secrets.doppler = {
      enable = lib.mkEnableOption "Doppler secrets provider baseline";

      package = lib.mkPackageOption pkgs "doppler" { };

      project = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default Doppler project name.";
      };

      configName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Default Doppler config name (for example dev or prod).";
      };

      tokenFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing a Doppler service token.";
      };
    };

    config =
      let
        cfg = config.secrets.doppler;
        lines = [
          (lib.optionalString (cfg.project != null) "DOPPLER_PROJECT=${cfg.project}")
          (lib.optionalString (cfg.configName != null) "DOPPLER_CONFIG=${cfg.configName}")
          (lib.optionalString (cfg.tokenFile != null) "DOPPLER_TOKEN_FILE=${toString cfg.tokenFile}")
        ];
        envText =
          let
            filtered = lib.filter (line: line != "") lines;
          in
          if filtered == [ ] then "" else lib.concatStringsSep "\n" filtered + "\n";
      in
      lib.mkIf cfg.enable {
        environment.systemPackages = [
          cfg.package
        ];

        environment.etc."doppler/env".text = envText;
      };
  };
}
