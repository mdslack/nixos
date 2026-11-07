{ inputs, ... }:
{
  flake.modules.nixos.wm-umbriel =
    { pkgs, ... }:
    let
      upstream = inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      imports = [ inputs.umbriel.nixosModules.default ];

      programs.umbriel.enable = true;
      programs.umbriel.package = pkgs.symlinkJoin {
        name = "umbriel-${upstream.version}";
        paths = [ upstream ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/umbriel --unset LD_LIBRARY_PATH
        '';
        passthru.providedSessions = [ "umbriel" ];
        meta = upstream.meta;
      };
      # Upstream's session unit starts its binary by absolute path. Both it
      # and the portal must avoid the session's older development libraries.
      systemd.user.services.umbriel.serviceConfig.UnsetEnvironment = [ "LD_LIBRARY_PATH" ];
      systemd.user.services.xdg-desktop-portal-umbriel.serviceConfig.UnsetEnvironment = [
        "LD_LIBRARY_PATH"
      ];
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.greetd.enableGnomeKeyring = true;
      security.pam.services.login.enableGnomeKeyring = true;
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      environment.systemPackages = with pkgs; [
        brightnessctl
        grim
        pamixer
        playerctl
        slurp
        swappy
        wl-clipboard
      ];

      nix.settings = {
        extra-substituters = [ "https://umbriel.cachix.org" ];
        extra-trusted-public-keys = [
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
        ];
      };
    };

  flake.modules.homeManager.wm-umbriel =
    { config, ... }:
    {
      home.sessionVariables.TERMINAL = "ghostty";
      xdg.configFile."umbriel/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/umbriel/config.toml";
    };
}
