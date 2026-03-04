_: {
  flake.modules.nixos.ai-codex =
    { lib, pkgsUnstable, ... }:
    let
      codexLatest = pkgsUnstable.stdenv.mkDerivation {
        pname = "codex";
        version = "0.107.0";

        src = pkgsUnstable.fetchurl {
          url = "https://github.com/openai/codex/releases/download/rust-v0.107.0/codex-x86_64-unknown-linux-gnu.tar.gz";
          hash = "sha256-6OqctfcbRo8yPPw3ftcXeIGYFeOJpgdrOCCFPHPiGNw=";
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
          pkgsUnstable.openssl
          pkgsUnstable.stdenv.cc.cc.lib
          pkgsUnstable.zlib
        ];

        installPhase = ''
          runHook preInstall
          install -d $out/bin
          tar -xf $src -C $out/bin
          mv $out/bin/codex-x86_64-unknown-linux-gnu $out/bin/codex
          chmod +x $out/bin/codex
          runHook postInstall
        '';

        postFixup = ''
          wrapProgram $out/bin/codex --prefix PATH : ${lib.makeBinPath [ pkgsUnstable.ripgrep ]}
        '';
      };
    in
    {
      environment.systemPackages = [
        codexLatest
      ];
    };
}
