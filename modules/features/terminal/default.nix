{pkgs, ...}: {
  flake.modules.nixos.features.terminal = {
    imports = [
      ./alacritty.nix
      ./ghostty.nix
      ./kitty.nix
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  flake.modules.homeManager.features.terminal = {
    imports = [
      ./alacritty.nix
      ./ghostty.nix
      ./kitty.nix
    ];
  };
}
