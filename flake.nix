{
  description = "NixOS workstation with full Dank Linux + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, dms, ... }:
    let
      system = "x86_64-linux";
      mkHost = {
        hostname,
        username,
        module,
      }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit hostname username;
          };
          modules = [
            dms.nixosModules.dank-material-shell
            dms.nixosModules.greeter
            module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit username;
              };
              home-manager.users.${username} = import ./home/mslack.nix;
            }
          ];
        };

      hosts = {
        workstation = {
          username = "mslack";
          module = ./hosts/workstation/configuration.nix;
        };
        meerkat = {
          username = "mslack";
          module = ./hosts/meerkat/configuration.nix;
        };
        framework = {
          username = "mslack";
          module = ./hosts/framework/configuration.nix;
        };
      };
    in {
      nixosConfigurations = nixpkgs.lib.mapAttrs
        (hostname: cfg:
          mkHost {
            inherit hostname;
            inherit (cfg) username module;
          })
        hosts;
    };
}
