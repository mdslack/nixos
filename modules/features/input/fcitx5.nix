{
  lib,
  ...
}: let
  rimeStatusIconPaths = [
    "icons/hicolor/16x16/status/fcitx-rime-zh.svg"
    "icons/hicolor/16x16/status/fcitx-rime-symbolic.svg"
    "icons/hicolor/16x16/status/fcitx-rime.svg"
    "icons/hicolor/16x16/status/fcitx_rime-symbolic.svg"
    "icons/hicolor/16x16/status/fcitx_rime.svg"
    "icons/hicolor/16x16/status/fcitx_rime_im-symbolic.svg"
    "icons/hicolor/16x16/status/fcitx_rime_im.svg"
    "icons/hicolor/16x16/status/org.fcitx.Fcitx5.fcitx-rime-symbolic.svg"
    "icons/hicolor/16x16/status/org.fcitx.Fcitx5.fcitx-rime.svg"
    "icons/hicolor/16x16/status/org.fcitx.Fcitx5.fcitx_rime-symbolic.svg"
    "icons/hicolor/16x16/status/org.fcitx.Fcitx5.fcitx_rime.svg"
    "icons/hicolor/16x16/status/org.fcitx.Fcitx5.fcitx_rime_im-symbolic.svg"
    "icons/hicolor/16x16/status/org.fcitx.Fcitx5.fcitx_rime_im.svg"
    "icons/hicolor/scalable/status/fcitx-rime-zh.svg"
    "icons/hicolor/scalable/status/fcitx-rime-symbolic.svg"
    "icons/hicolor/scalable/status/fcitx-rime.svg"
    "icons/hicolor/scalable/status/fcitx_rime-symbolic.svg"
    "icons/hicolor/scalable/status/fcitx_rime.svg"
    "icons/hicolor/scalable/status/fcitx_rime_im-symbolic.svg"
    "icons/hicolor/scalable/status/fcitx_rime_im.svg"
    "icons/hicolor/scalable/status/org.fcitx.Fcitx5.fcitx-rime-symbolic.svg"
    "icons/hicolor/scalable/status/org.fcitx.Fcitx5.fcitx-rime.svg"
    "icons/hicolor/scalable/status/org.fcitx.Fcitx5.fcitx_rime-symbolic.svg"
    "icons/hicolor/scalable/status/org.fcitx.Fcitx5.fcitx_rime.svg"
    "icons/hicolor/scalable/status/org.fcitx.Fcitx5.fcitx_rime_im-symbolic.svg"
    "icons/hicolor/scalable/status/org.fcitx.Fcitx5.fcitx_rime_im.svg"
  ];

  rimeAppSvgIconPaths = [
    "icons/hicolor/scalable/apps/fcitx-rime-zh.svg"
    "icons/hicolor/scalable/apps/fcitx-rime.svg"
    "icons/hicolor/scalable/apps/fcitx_rime.svg"
    "icons/hicolor/scalable/apps/fcitx_rime_im.svg"
    "icons/hicolor/scalable/apps/org.fcitx.Fcitx5.fcitx-rime.svg"
    "icons/hicolor/scalable/apps/org.fcitx.Fcitx5.fcitx_rime.svg"
    "icons/hicolor/scalable/apps/org.fcitx.Fcitx5.fcitx_rime_im.svg"
  ];

  rimeAppPngIconPaths = [
    "icons/hicolor/32x32/apps/fcitx-rime-zh.png"
    "icons/hicolor/32x32/apps/fcitx-rime.png"
    "icons/hicolor/32x32/apps/fcitx_rime.png"
    "icons/hicolor/32x32/apps/fcitx_rime_im.png"
    "icons/hicolor/48x48/apps/fcitx-rime-zh.png"
    "icons/hicolor/48x48/apps/fcitx-rime.png"
    "icons/hicolor/48x48/apps/fcitx_rime.png"
    "icons/hicolor/48x48/apps/fcitx_rime_im.png"
    "icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-rime.png"
    "icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx_rime.png"
    "icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx_rime_im.png"
  ];

  mkDataFiles = paths: source:
    lib.genAttrs paths (_: {
      inherit source;
    });

  keyboardThemeOverridePaths = [
    "icons/breeze/devices/16/input-keyboard-symbolic.svg"
    "icons/breeze/devices/22/input-keyboard-symbolic.svg"
    "icons/breeze/devices/24/input-keyboard-symbolic.svg"
    "icons/breeze/devices/32/input-keyboard-symbolic.svg"
    "icons/breeze/devices/48/input-keyboard-symbolic.svg"
    "icons/breeze/devices/64/input-keyboard-symbolic.svg"
    "icons/breeze-dark/devices/16/input-keyboard-symbolic.svg"
    "icons/breeze-dark/devices/22/input-keyboard-symbolic.svg"
    "icons/breeze-dark/devices/24/input-keyboard-symbolic.svg"
    "icons/breeze-dark/devices/32/input-keyboard-symbolic.svg"
    "icons/breeze-dark/devices/48/input-keyboard-symbolic.svg"
    "icons/breeze-dark/devices/64/input-keyboard-symbolic.svg"
    "icons/Papirus/16x16/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus/22x22/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus/24x24/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus/32x32/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus/48x48/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus/64x64/devices/input-keyboard-symbolic.svg"
    "icons/Papirus-Dark/16x16/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus-Dark/22x22/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus-Dark/24x24/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus-Dark/32x32/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus-Dark/48x48/symbolic/devices/input-keyboard-symbolic.svg"
    "icons/Papirus-Dark/64x64/devices/input-keyboard-symbolic.svg"
  ];

  rimeThemeOverridePaths = [
    "icons/breeze/status/22/fcitx-rime.svg"
    "icons/breeze/status/24/fcitx-rime.svg"
    "icons/breeze/status/32/fcitx-rime.svg"
    "icons/breeze/status/48/fcitx-rime.svg"
    "icons/breeze/status/64/fcitx-rime.svg"
    "icons/breeze/status/22/fcitx_rime.svg"
    "icons/breeze/status/24/fcitx_rime.svg"
    "icons/breeze/status/32/fcitx_rime.svg"
    "icons/breeze/status/48/fcitx_rime.svg"
    "icons/breeze/status/64/fcitx_rime.svg"
    "icons/breeze/status/22/fcitx_rime_im.svg"
    "icons/breeze/status/24/fcitx_rime_im.svg"
    "icons/breeze/status/32/fcitx_rime_im.svg"
    "icons/breeze/status/48/fcitx_rime_im.svg"
    "icons/breeze/status/64/fcitx_rime_im.svg"
    "icons/breeze-dark/status/22/fcitx-rime.svg"
    "icons/breeze-dark/status/24/fcitx-rime.svg"
    "icons/breeze-dark/status/32/fcitx-rime.svg"
    "icons/breeze-dark/status/48/fcitx-rime.svg"
    "icons/breeze-dark/status/64/fcitx-rime.svg"
    "icons/breeze-dark/status/22/fcitx_rime.svg"
    "icons/breeze-dark/status/24/fcitx_rime.svg"
    "icons/breeze-dark/status/32/fcitx_rime.svg"
    "icons/breeze-dark/status/48/fcitx_rime.svg"
    "icons/breeze-dark/status/64/fcitx_rime.svg"
    "icons/breeze-dark/status/22/fcitx_rime_im.svg"
    "icons/breeze-dark/status/24/fcitx_rime_im.svg"
    "icons/breeze-dark/status/32/fcitx_rime_im.svg"
    "icons/breeze-dark/status/48/fcitx_rime_im.svg"
    "icons/breeze-dark/status/64/fcitx_rime_im.svg"
    "icons/Papirus/16x16/actions/fcitx-rime.svg"
    "icons/Papirus/22x22/actions/fcitx-rime.svg"
    "icons/Papirus/24x24/actions/fcitx-rime.svg"
    "icons/Papirus/32x32/actions/fcitx-rime.svg"
    "icons/Papirus/48x48/actions/fcitx-rime.svg"
    "icons/Papirus/64x64/actions/fcitx-rime.svg"
    "icons/Papirus-Dark/16x16/actions/fcitx-rime.svg"
    "icons/Papirus-Dark/22x22/actions/fcitx-rime.svg"
    "icons/Papirus-Dark/24x24/actions/fcitx-rime.svg"
    "icons/Papirus-Dark/32x32/actions/fcitx-rime.svg"
    "icons/Papirus-Dark/48x48/actions/fcitx-rime.svg"
    "icons/Papirus-Dark/64x64/actions/fcitx-rime.svg"
  ];
in {
  flake.modules.nixos.input-fcitx5 =
    { pkgs, ... }:
    let
      fcitx5RimePatched = pkgs.fcitx5-rime.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          install -Dm644 ${../../../assets/icons/fcitx-rime.png} "$out/share/icons/hicolor/48x48/apps/fcitx-rime.png"
          install -Dm644 ${../../../assets/icons/fcitx-rime.png} "$out/share/icons/hicolor/48x48/apps/fcitx_rime_im.png"
          install -Dm644 ${../../../assets/icons/fcitx-rime.png} "$out/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-rime.png"
          install -Dm644 ${../../../assets/icons/fcitx-rime.svg} "$out/share/icons/hicolor/scalable/apps/fcitx-rime.svg"
          install -Dm644 ${../../../assets/icons/fcitx-rime.svg} "$out/share/icons/hicolor/scalable/apps/fcitx_rime_im.svg"
          install -Dm644 ${../../../assets/icons/fcitx-rime.svg} "$out/share/icons/hicolor/scalable/apps/org.fcitx.Fcitx5.fcitx-rime.svg"
        '';
      });
    in
    {
      environment.systemPackages = with pkgs; [
        rime-data
      ];

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
      ];

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons =
          (with pkgs; [
            fcitx5RimePatched
            fcitx5-gtk
          ])
          ++ (with pkgs.qt6Packages; [
            fcitx5-chinese-addons
            fcitx5-configtool
            fcitx5-qt
          ]);
      };
    };

  flake.modules.homeManager.input-fcitx5 =
    { ... }:
    {
      xdg.configFile."fcitx5/conf/classicui.conf".text = ''
        PreferTextIcon=False
        ShowLayoutNameInIcon=False
        UseInputMethodLanguageToDisplayText=False
      '';

      xdg.dataFile =
        {
          "icons/hicolor/scalable/status/input-keyboard-symbolic.svg".source =
            ../../../assets/icons/input-keyboard-symbolic.svg;

          "icons/hicolor/16x16/status/input-keyboard-symbolic.svg".source =
            ../../../assets/icons/input-keyboard-symbolic.svg;

          "icons/hicolor/scalable/apps/input-keyboard.svg".source =
            ../../../assets/icons/input-keyboard.svg;
        }
        // mkDataFiles keyboardThemeOverridePaths ../../../assets/icons/input-keyboard-symbolic.svg
        // mkDataFiles rimeStatusIconPaths ../../../assets/icons/fcitx-rime.svg
        // mkDataFiles rimeAppSvgIconPaths ../../../assets/icons/fcitx-rime.svg
        // mkDataFiles rimeAppPngIconPaths ../../../assets/icons/fcitx-rime.png
        // mkDataFiles rimeThemeOverridePaths ../../../assets/icons/fcitx-rime.svg;
    };
}
