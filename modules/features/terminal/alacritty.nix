_: {
  flake.modules.nixos.terminal-alacritty =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.alacritty
      ];
    };

  flake.modules.homeManager.terminal-alacritty = {
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
