{pkgs, ...}: {
  flake.modules.nixos.features.terminal.kitty = {
    environment.systemPackages = [
      pkgs.kitty
    ];
  };

  flake.modules.homeManager.features.terminal.kitty = {
    programs.kitty = {
      enable = true;
      settings = {
        font_family = "JetBrains Mono Nerd Font";
        font_size = 12;
        background_opacity = "0.9";
        window_padding_width = 25;
      };
    };
  };
}
