_:
let
  mkAntigravity =
    pkgs:
    pkgs.stdenv.mkDerivation {
      pname = "antigravity-cli";
      version = "1.5.13";

      src = pkgs.fetchurl {
        url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/1.5.13-5999302598852608/linux-x64/cli_linux_x64.tar.gz";
        hash = "sha512-AUs3OHcDrKsfR81TLIu2AWemo1N7D5iR3gPxsf+pYUMHvIPEsvdVEnOwh31yJxawzZ4meC9rKlBwXbTwXhjGjw==";
      };

      dontUnpack = true;
      dontStrip = true;
      nativeBuildInputs = [
        pkgs.autoPatchelfHook
        pkgs.makeBinaryWrapper
      ];

      installPhase = ''
        runHook preInstall
        tar -xzf $src
        install -Dm755 antigravity $out/bin/agy
        runHook postInstall
      '';

      postFixup = ''
        wrapProgram $out/bin/agy \
          --set AGY_CLI_DISABLE_AUTO_UPDATE 1 \
          --prefix PATH : ${
            pkgs.lib.makeBinPath [
              pkgs.bubblewrap
              pkgs.ripgrep
            ]
          }
      '';

      meta = {
        description = "Google Antigravity's coding agent for the terminal";
        homepage = "https://antigravity.google/docs/getting-started?tab=cli";
        license = pkgs.lib.licenses.unfree;
        platforms = [ "x86_64-linux" ];
        mainProgram = "agy";
      };
    };
in
{
  flake.modules.nixos.ai-antigravity =
    { pkgs, ... }:
    {
      environment.systemPackages = [ (mkAntigravity pkgs) ];
    };
}
