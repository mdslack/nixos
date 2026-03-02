{inputs, ...}: {
  flake.modules.nixos.theme-stylix = {
    pkgs,
    ...
  }: {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];

    config = {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        targets.neovim.enable = false;
        targets.yazi.enable = false;
      };
    };
  };
}
