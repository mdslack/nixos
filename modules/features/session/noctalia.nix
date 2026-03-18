{inputs, ...}: {
  flake.modules.nixos.session-noctalia = {pkgs, ...}: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    environment.systemPackages = [
      pkgs.swayidle
    ];

    systemd.user.services.swayidle = {
      description = "Swayidle Service";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.swayidle}/bin/swayidle -w \
            timeout 300 "${pkgs.quickshell}/bin/qs -c noctalia-shell ipc call lockScreen lock" \
            timeout 600 "${pkgs.quickshell}/bin/qs -c noctalia-shell ipc call sessionMenu lockAndSuspend"
        '';
        Restart = "on-failure";
        TimeoutSec = 30;
      };
    };

    services.noctalia-shell.enable = true;
  };

  flake.modules.homeManager.session-noctalia = {
    config,
    lib,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = lib.mkForce {};
    };

    xdg.configFile."noctalia" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia";
      recursive = true;
    };
  };
}
