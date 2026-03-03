{ lib, ... }:
{
  options.flake.meta = lib.mkOption {
    type = with lib.types; lazyAttrsOf anything;
    default = { };
  };

  config.flake.meta.stateVersions = {
    system = "25.11";
    home = "25.11";
  };
}
