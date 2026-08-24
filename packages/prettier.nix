{
  fetchurl,
  lib,
  makeWrapper,
  nodejs,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "prettier";
  version = "3.9.6";

  src = fetchurl {
    url = "https://registry.npmjs.org/prettier/-/prettier-${finalAttrs.version}.tgz";
    hash = "sha256-mX2pXPKugQU8r8ee8SKm6NwS4/LGGdV+sfLhlSX7IS8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/node_modules/prettier"
    cp -r . "$out/lib/node_modules/prettier"
    makeWrapper "${lib.getExe nodejs}" "$out/bin/prettier" \
      --add-flags "$out/lib/node_modules/prettier/bin/prettier.cjs"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test "$("$out/bin/prettier" --version)" = "${finalAttrs.version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "Opinionated code formatter";
    homepage = "https://prettier.io/";
    license = lib.licenses.mit;
    mainProgram = "prettier";
  };
})
