{pkgs, ...}: {
  flake.modules.nixos.features.terminal.alacritty = {
    environment.systemPackages = [
      pkgs.alacritty
    ];
  };

  flake.modules.homeManager.features.terminal.alacritty = {
    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 12;
        window = {
          opacity = 0.9;
          padding = {
            x = 25;
            y = 25;
          };
        };
      };
    };
  };
}
