_: {
  flake.modules.nixos.terminal-fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        corefonts
        inter
        lexend
        merriweather
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
      ];
    };
}
