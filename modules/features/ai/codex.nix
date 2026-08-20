_:
let
  mkCodexLatest =
    { lib, pkgsUnstable }:
    pkgsUnstable.stdenv.mkDerivation {
      pname = "codex";
      version = "0.148.0";

      src = pkgsUnstable.fetchurl {
        url = "https://github.com/openai/codex/releases/download/rust-v0.148.0/codex-package-x86_64-unknown-linux-musl.tar.gz";
        hash = "sha256-jHkFAK8rpudM5JSP4mxlGsH3f227AFtHyNJv9xEUYmI=";
      };

      dontUnpack = true;

      nativeBuildInputs = [
        pkgsUnstable.autoPatchelfHook
        pkgsUnstable.gnutar
        pkgsUnstable.installShellFiles
        pkgsUnstable.makeBinaryWrapper
      ];

      buildInputs = [
        pkgsUnstable.libcap
        pkgsUnstable.ncurses
        pkgsUnstable.openssl
        pkgsUnstable.stdenv.cc.cc.lib
        pkgsUnstable.zlib
      ];

      installPhase = ''
        runHook preInstall
        install -d $out
        tar -xf $src -C $out
        chmod +x $out/bin/codex
        # Match the standalone install layout used by remote-control's daemon.
        ln -s bin/codex $out/codex
        runHook postInstall
      '';

      postFixup = ''
        wrapProgram $out/bin/codex --prefix PATH : ${
          lib.makeBinPath [
            pkgsUnstable.bubblewrap
            pkgsUnstable.ripgrep
          ]
        }
      '';
    };
in
{
  flake.modules.nixos.ai-codex =
    { lib, pkgsUnstable, ... }:
    let
      codexLatest = mkCodexLatest { inherit lib pkgsUnstable; };
    in
    {
      environment.systemPackages = [
        codexLatest
      ];
    };

  flake.modules.homeManager.ai-codex =
    {
      config,
      lib,
      pkgs,
      pkgsUnstable,
      ...
    }:
    let
      codexLatest = mkCodexLatest { inherit lib pkgsUnstable; };
      codexSkillDirs = [
        "rust-development"
      ];
    in
    {
      home.file =
        lib.listToAttrs (
          map (name: {
            name = ".codex/skills/${name}";
            value = {
              source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/codex/skills/${name}";
              recursive = true;
            };
          }) codexSkillDirs
        )
        // {
          # Keep the daemon's fixed standalone path under Home Manager ownership.
          ".codex/packages/standalone/current" = {
            source = codexLatest;
            force = true;
          };
        };

      home.activation.removeCodexStandaloneSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        codex_link="$HOME/.local/bin/codex"
        standalone_root="$HOME/.codex/packages/standalone"

        if [ -L "$codex_link" ]; then
          codex_target="$(${pkgs.coreutils}/bin/readlink "$codex_link" 2>/dev/null || true)"
          codex_resolved="$(${pkgs.coreutils}/bin/readlink -f "$codex_link" 2>/dev/null || true)"

          case "$codex_target" in
            "$standalone_root"/*)
              rm -f "$codex_link"
              ;;
          esac

          case "$codex_resolved" in
            "$standalone_root"/*)
              rm -f "$codex_link"
              ;;
          esac
        fi
      '';
    };
}
