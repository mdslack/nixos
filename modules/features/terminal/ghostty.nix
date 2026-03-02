{pkgs, ...}: {
  flake.modules.nixos.features.terminal.ghostty = {
    environment.systemPackages = [
      pkgs.ghostty
    ];
  };

  flake.modules.homeManager.features.terminal.ghostty = {
    programs.ghostty = {
      enable = true;
      settings = {
        "font-family" = "JetBrains Mono Nerd Font";
        "font-size" = 12;
        "background-opacity" = 0.9;
        "window-padding-x" = 25;
        "window-padding-y" = 25;
      };
    };
  };
}
