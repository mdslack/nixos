_: {
  perSystem =
    {
      config,
      ...
    }:
    {
      dev.shellSets.base = with config._module.args.pkgs; [
        git
        git-lfs
        gh
        lazygit
        curl
        wget
        btop
        bat
        ripgrep
        fd
        fzf
        jq
        just
        tmux
      ];
    };
}
