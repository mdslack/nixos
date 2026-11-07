_: {
  flake.modules.nixos.network-mosh =
    { pkgs, ... }:
    {
      # Installs mosh-server and opens UDP 60000–61000 for its sessions.
      programs.mosh.enable = true;

      # Set the supported timeout at the server entry point: the SSH environment
      # alone does not survive every client's bootstrap. This measures network
      # silence, not keyboard inactivity; Herdr Core keeps the agents running.
      programs.mosh.package = pkgs.symlinkJoin {
        name = "mosh-with-network-timeout";
        paths = [ pkgs.mosh ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/mosh-server" \
            --set MOSH_SERVER_NETWORK_TMOUT 300
        '';
        meta = pkgs.mosh.meta;
      };
    };
}
