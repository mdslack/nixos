{
  description = "NixOS Flake Parts Entry-point";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    rust-overlay.url = "github:oxalica/rust-overlay";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/v5.4.1";
      inputs.nixpkgs.follows = "nixpkgs-apps";
    };
    nixpkgs-apps.url = "github:NixOS/nixpkgs/nixos-unstable";
    niri = {
      # Includes the virtual-keyboard rewrite and subsequent fcitx5/wtype fixes.
      url = "github:niri-wm/niri/9955d921ce6491e34fb74ec94f30a7cca76826e4";
      inputs.nixpkgs.follows = "nixpkgs-apps";
    };
    # Keep Umbriel's own nixpkgs lock to match its official binary cache.
    umbriel.url = "github:noctalia-dev/umbriel/7ffde7901bbed0ad67f0b1167c10792924ab9066";
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter/effcb9ffc33f7120cbc6cfc6c6527e9da763a0e9";
      inputs.nixpkgs.follows = "umbriel/nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
