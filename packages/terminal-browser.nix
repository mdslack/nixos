{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  vulkan-loader,
  xorg,
}:
stdenv.mkDerivation {
  pname = "terminal-browser";
  version = "0.15.2";

  src = fetchurl {
    url = "https://github.com/zenbu-labs/terminal-browser/releases/download/v0.15.2/terminal-browser-linux-x64.tar.gz";
    hash = "sha256-loGpTbes4QbM6GvxTcs/y6ekBOXmYOcL+c63Ks42sUY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];
  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libxkbcommon
    nspr
    nss
    pango
    stdenv.cc.cc
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];
  runtimeDependencies = [
    (lib.getLib systemd)
    (lib.getLib libGL)
    (lib.getLib vulkan-loader)
  ];

  dontBuild = true;
  dontWrapGApps = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/terminal-browser $out/bin
    cp -a . $out/lib/terminal-browser/
    runHook postInstall
  '';
  preFixup = ''
    makeWrapper $out/lib/terminal-browser/bin/terminal-browser $out/bin/terminal-browser \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Chromium browser rendered inside a terminal";
    homepage = "https://github.com/zenbu-labs/terminal-browser";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "terminal-browser";
  };
}
