{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "orca-ide";
  version = "1.4.238";

  src = fetchurl {
    url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
    hash = "sha256-ep+stcQhysRbEdKu/UEo8uxvbpreFuyNfkEk17pM0Sc=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # AppRun uses unshare to detect support for Electron's sandbox.
  extraPkgs = pkgs: [ pkgs.util-linux ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/orca-ide.desktop \
      $out/share/applications/orca-ide.desktop
    substituteInPlace $out/share/applications/orca-ide.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=orca-ide'
    mkdir -p $out/share/icons
    cp -r ${appimageContents}/usr/share/icons/hicolor $out/share/icons/
  '';

  meta = {
    description = "Development environment for parallel coding agents";
    homepage = "https://orca.dev";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "orca-ide";
  };
}
