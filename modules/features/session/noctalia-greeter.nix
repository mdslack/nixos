{ inputs, ... }:
{
  flake.modules.nixos.session-noctalia-greeter =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      greeterUser = config.services.greetd.settings.default_session.user;
      greeterGroup = config.users.users.${greeterUser}.group;
      source = "${config.users.users.mslack.home}/dotfiles/noctalia-greeter/greeter.toml";
      syncConfig = pkgs.writeShellScript "sync-noctalia-greeter-config" ''
        set -eu
        if ! test -f ${lib.escapeShellArg source}; then
          echo "Missing Noctalia Greeter configuration: ${source}" >&2
          exit 1
        fi
        ${pkgs.coreutils}/bin/install -d -m0750 \
          -o ${lib.escapeShellArg greeterUser} -g ${lib.escapeShellArg greeterGroup} \
          /var/lib/noctalia-greeter
        ${pkgs.coreutils}/bin/install -T -m0640 -o root -g ${lib.escapeShellArg greeterGroup} \
          ${lib.escapeShellArg source} /var/lib/noctalia-greeter/greeter.toml
      '';
    in
    {
      imports = [ inputs.noctalia-greeter.nixosModules.default ];

      services.displayManager.noctalia-greeter.enable = true;
      services.greetd.settings.default_session.user = "greeter";
      # greetd's login shell loads the global development library path. Clear it
      # after that shell starts so the greeter uses its own C++/graphics libraries.
      services.greetd.settings.default_session.command =
        "${lib.getExe' pkgs.coreutils "env"} -u LD_LIBRARY_PATH "
        + "XDG_DATA_DIRS=${config.services.displayManager.sessionData.desktops}/share "
        + "${config.services.displayManager.noctalia-greeter.package}/bin/noctalia-greeter-session -- "
        + config.services.displayManager.noctalia-greeter.greeter-args;

      # The greeter cannot traverse a private home directory. Keep the editable
      # source in dotfiles and deploy a readable copy before the login UI starts.
      systemd.services.greetd.preStart = lib.mkBefore "${syncConfig}";
      system.activationScripts.noctalia-greeter-config = {
        deps = [ "users" ];
        text = "${syncConfig}";
      };
    };

  flake.modules.homeManager.session-noctalia-greeter =
    { config, ... }:
    {
      xdg.configFile."noctalia-greeter/greeter.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/noctalia-greeter/greeter.toml";
    };
}
