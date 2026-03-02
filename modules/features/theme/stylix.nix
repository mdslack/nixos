{
  inputs,
  lib,
  options,
  pkgs,
  ...
}: {
  flake.modules.nixos.theme = {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];

    config = {
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      };
    }
    // lib.optionalAttrs (lib.hasAttrByPath ["stylix" "targets" "neovim" "enable"] options) {
      stylix.targets.neovim.enable = false;
    }
    // lib.optionalAttrs (lib.hasAttrByPath ["stylix" "targets" "yazi" "enable"] options) {
      stylix.targets.yazi.enable = false;
    };
  };
}
