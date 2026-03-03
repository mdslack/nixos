_: {
  flake.modules.nixos.virtualization-containers =
    { pkgs, ... }:
    {
      virtualisation.containers.enable = true;

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      environment.systemPackages = with pkgs; [
        podman-compose
        distrobox
      ];
    };

  flake.modules.homeManager.virtualization-containers = {
    programs.bash.shellAliases = {
      dps = "podman ps";
      dpsa = "podman ps -a";
      dimg = "podman images";
      dlog = "podman logs -f";
      dcu = "podman compose up -d";
      dcd = "podman compose down";
      dcb = "podman compose build";
      dce = "podman compose exec";
      dbox = "distrobox";
    };

    programs.zsh.shellAliases = {
      dps = "podman ps";
      dpsa = "podman ps -a";
      dimg = "podman images";
      dlog = "podman logs -f";
      dcu = "podman compose up -d";
      dcd = "podman compose down";
      dcb = "podman compose build";
      dce = "podman compose exec";
      dbox = "distrobox";
    };
  };
}
