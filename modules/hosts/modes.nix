{...}: {
  flake.meta.hostModes = {
    minimal = [
      "minimal"
    ];
    cosmic = [
      "minimal"
      "desktop-cosmic"
    ];
    gnome = [
      "minimal"
      "desktop-gnome"
    ];
    kde = [
      "minimal"
      "desktop-kde"
    ];
    hyprland = [
      "minimal"
      "wm-hyprland"
    ];
    hyprland-dms = [
      "minimal"
      "wm-hyprland"
      "session-dms"
    ];
    hyprland-noctalia = [
      "minimal"
      "wm-hyprland"
      "session-noctalia"
    ];
    niri = [
      "minimal"
      "wm-niri"
    ];
    niri-dms = [
      "minimal"
      "wm-niri"
      "session-dms"
    ];
    niri-noctalia = [
      "minimal"
      "wm-niri"
      "session-noctalia"
    ];
  };
}
