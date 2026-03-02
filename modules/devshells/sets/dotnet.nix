{...}: {
  perSystem = {
    config,
    ...
  }: {
    dev.shellSets.dotnet = with config._module.args.pkgs; [
      dotnet-sdk
    ];
  };
}
