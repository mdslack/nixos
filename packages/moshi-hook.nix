{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "moshi-hook";
  version = "0.4.43";

  src = fetchurl {
    url = "https://cdn.getmoshi.app/hook/v${finalAttrs.version}/moshi-hook_Linux_x86_64.tar.gz";
    hash = "sha256-r8OzaxD1TdXiYR045TDn/ozT6cMKenWsl8LGQwg349Y=";
  };

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 moshi-hook $out/bin/moshi-hook
    ln -s moshi-hook $out/bin/moshi
    install -Dm644 README.md $out/share/doc/moshi-hook/README.md
    cp -r docs $out/share/doc/moshi-hook/
    runHook postInstall
  '';

  meta = {
    description = "Companion daemon and CLI for Moshi agent hooks";
    homepage = "https://getmoshi.app";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "moshi-hook";
  };
})
