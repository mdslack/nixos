_: {
  flake.modules.nixos.ai-opencode =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.opencode
      ];
    };

  flake.modules.homeManager.ai-opencode = {
    home.file.".opencode/opencode.jsonc".text = ''
      {
        "$schema": "https://opencode.ai/config.json",
        "keybinds": {
          "variant_cycle": "ctrl+tab"
        }
      }
    '';
  };
}
