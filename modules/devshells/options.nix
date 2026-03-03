{ lib, ... }:
{
  perSystem = _: {
    options.dev.shellSets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.package);
      default = { };
      description = "Composable package sets for development shells.";
    };
  };
}
