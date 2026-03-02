{pkgs, ...}: {
  flake.modules.nixos.features.input.fcitx5 = {
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
          fcitx5-rime
          fcitx5-gtk
        ])
        ++ (with pkgs.qt6Packages; [
          fcitx5-chinese-addons
          fcitx5-configtool
          fcitx5-qt
        ]);
    };
  };
}
