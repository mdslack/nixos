_: {
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
      xdg.dataFile."icons/hicolor/scalable/status/input-keyboard-symbolic.svg".source =
        ../../../assets/icons/input-keyboard-symbolic.svg;

      xdg.dataFile."icons/hicolor/16x16/status/input-keyboard-symbolic.svg".source =
        ../../../assets/icons/input-keyboard-symbolic.svg;

      xdg.dataFile."icons/hicolor/scalable/apps/input-keyboard.svg".source =
        ../../../assets/icons/input-keyboard.svg;
    };
}
