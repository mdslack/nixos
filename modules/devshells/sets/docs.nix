_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.docs = with config._module.args.pkgs; [
        pandoc
        mermaid-cli
        markdownlint-cli
        mdbook
        poppler-utils
        qpdf
        texlive.combined.scheme-full
      ];
    };
}
