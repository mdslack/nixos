_: {
  flake.modules.nixos.controls-keylightd =
    { lib, pkgs, ... }:
    let
      version = "0.1.6";
      system = pkgs.stdenv.hostPlatform.system;

      archives = {
        x86_64-linux = {
          arch = "amd64";
          hash = "sha256-3j5i4JUY5Eo+g/JUI56L7D6DoLXHfPdoHpeVBnoSuUQ=";
        };
        aarch64-linux = {
          arch = "arm64";
          hash = "sha256-2Wr+GD1lp6BYcJbxczSJxrF/QWAeFFUGUTh0qp3hlCc=";
        };
      };

      archive = archives.${system} or (throw "keylightd is not packaged for ${system}");

      keylightd = pkgs.stdenvNoCC.mkDerivation {
        pname = "keylightd";
        inherit version;

        src = pkgs.fetchurl {
          url = "https://github.com/jmylchreest/keylightd/releases/download/v${version}/keylightd_${version}_linux_${archive.arch}.tar.gz";
          inherit (archive) hash;
        };

        sourceRoot = ".";

        installPhase = ''
          runHook preInstall

          install -Dm755 keylightd "$out/bin/keylightd"
          install -Dm755 keylightctl "$out/bin/keylightctl"
          install -Dm644 LICENSE "$out/share/licenses/keylightd/LICENSE"
          install -Dm644 README.md "$out/share/doc/keylightd/README.md"

          runHook postInstall
        '';

        meta = {
          description = "Daemon and CLI for discovering, monitoring, and controlling Elgato Key Light devices";
          homepage = "https://github.com/jmylchreest/keylightd";
          license = lib.licenses.mit;
          mainProgram = "keylightctl";
          platforms = builtins.attrNames archives;
          sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
        };
      };
    in
    {
      environment.systemPackages = [ keylightd ];

      users.groups.keylightd = { };

      users.users = {
        keylightd = {
          isSystemUser = true;
          group = "keylightd";
          description = "Key Light Daemon";
          home = "/var/lib/keylightd";
        };

        mslack.extraGroups = [ "keylightd" ];
      };

      # Elgato Key Lights are discovered through mDNS on the local network.
      networking.firewall.allowedUDPPorts = [ 5353 ];

      systemd.services.keylightd = {
        description = "Key Light Daemon";
        documentation = [ "https://github.com/jmylchreest/keylightd" ];
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];

        serviceConfig = {
          ExecStart = "${keylightd}/bin/keylightd";
          Restart = "on-failure";
          RestartSec = "10s";

          User = "keylightd";
          Group = "keylightd";
          StateDirectory = "keylightd";
          RuntimeDirectory = "keylightd";
          RuntimeDirectoryMode = "0775";
          UMask = "0002";

          Environment = [
            "XDG_CONFIG_HOME=/var/lib/keylightd"
            "XDG_RUNTIME_DIR=/run/keylightd"
            "KEYLIGHT_CONFIG_API_LISTEN_ADDRESS=127.0.0.1:9123"
          ];

          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          SystemCallFilter = [ "@system-service" ];
          SystemCallErrorNumber = "EPERM";
        };
      };
    };
}
