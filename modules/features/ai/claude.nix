_:
let
  mkClaudeLatest =
    pkgs:
    pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "claude-code";
      version = "2.1.310";

      src = pkgs.fetchurl {
        url = "https://downloads.claude.ai/claude-code-releases/${finalAttrs.version}/linux-x64/claude";
        hash = "sha256-tzZ2QwrxL5cxanmLg3H4HWQPkKWL3LjzzlaoNbtH31Y=";
      };

      dontUnpack = true;
      # Bun's executable contains an embedded application that stripping can damage.
      dontStrip = true;
      nativeBuildInputs = [
        pkgs.autoPatchelfHook
        pkgs.makeBinaryWrapper
      ];
      buildInputs = [ pkgs.stdenv.cc.cc.lib ];

      installPhase = ''
        runHook preInstall
        install -Dm755 $src $out/bin/claude
        runHook postInstall
      '';

      postFixup = ''
        wrapProgram $out/bin/claude \
          --set DISABLE_AUTOUPDATER 1 \
          --set USE_BUILTIN_RIPGREP 0 \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ripgrep ]} \
          --unset DEV
      '';

      meta = {
        description = "Anthropic's coding agent for the terminal";
        homepage = "https://code.claude.com";
        license = pkgs.lib.licenses.unfree;
        platforms = [ "x86_64-linux" ];
        mainProgram = "claude";
      };
    });
in
{
  flake.modules.nixos.ai-claude =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (mkClaudeLatest pkgs)
      ];
    };
}
