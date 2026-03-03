_: {
  flake.meta.hostModes = {
    minimal = [
      "minimal"
    ];
    cosmic = [
      "minimal"
      "bundle-desktop-cosmic"
    ];
    gnome = [
      "minimal"
      "bundle-desktop-gnome"
    ];
    kde = [
      "minimal"
      "bundle-desktop-kde"
    ];
    hyprland = [
      "minimal"
      "bundle-wm-hyprland"
    ];
    hyprland-dms = [
      "minimal"
      "bundle-wm-hyprland"
      "bundle-session-dms"
    ];
    hyprland-noctalia = [
      "minimal"
      "bundle-wm-hyprland"
      "bundle-session-noctalia"
    ];
    niri = [
      "minimal"
      "bundle-wm-niri"
    ];
    niri-dms = [
      "minimal"
      "bundle-wm-niri"
      "bundle-session-dms"
    ];
    niri-noctalia = [
      "minimal"
      "bundle-wm-niri"
      "bundle-session-noctalia"
    ];
  };
}
