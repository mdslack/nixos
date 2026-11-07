{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  herdr-core,
  libxkbcommon,
  xorg,
  wayland,
  libglvnd,
  vulkan-loader,
  curl,
  openssh,
  libnotify,
  xdg-utils,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "herdr-app";
  version = "0.1.13";

  src = fetchurl {
    url = "https://releases.herdr.dev/app/${finalAttrs.version}/herdr-app-linux-x86_64.tar.gz";
    hash = "sha256-d7C+cqRsoUuzZzZaBBZGQfkUs6aXErrDkdOcVqlZvvQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [
    libxkbcommon
    xorg.libxcb
    stdenv.cc.cc.lib
  ];
  runtimeDependencies = [
    wayland
    libglvnd
    vulkan-loader
  ];
  dontBuild = true;
  dontStrip = true;

  desktopItems = [
    (makeDesktopItem {
      name = "herdr-app";
      desktopName = "Herdr Desktop";
      comment = "Terminals and coding agents that keep running";
      exec = "herdr-app";
      icon = "herdr-app";
      categories = [
        "Development"
        "TerminalEmulator"
      ];
      startupWMClass = "herdr-app";
    })
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 herdr-app $out/bin/herdr-app
    # Keep the icon out of bin: upstream enables its self-updater only when
    # the icon sits beside the executable. Nix owns this installation.
    install -Dm644 herdr-app.svg $out/share/icons/hicolor/scalable/apps/herdr-app.svg
    install -Dm644 LICENSE $out/share/licenses/herdr-app/LICENSE
    install -Dm644 THIRD-PARTY-NOTICES $out/share/doc/herdr-app/THIRD-PARTY-NOTICES
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/herdr-app \
      --prefix PATH : ${
        lib.makeBinPath [
          herdr-core
          curl
          openssh
          libnotify
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          libglvnd
          vulkan-loader
        ]
      }
  '';

  meta = {
    description = "Native desktop app for persistent terminals and coding agents";
    homepage = "https://herdr.dev/";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "herdr-app";
  };
})
