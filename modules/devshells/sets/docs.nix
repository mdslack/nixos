{...}: {
  perSystem = {
    config,
    ...
  }: {
    dev.shellSets.docs = with config._module.args.pkgs; [
      pandoc
      mermaid-cli
      mdbook
      texlive.combined.scheme-medium
    ];
  };
}
