_: {
  flake.modules.nixos.network-mosh = {
    # Installs mosh-server and opens UDP 60000–61000 for its sessions.
    programs.mosh.enable = true;
  };
}
