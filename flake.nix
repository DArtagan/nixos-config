{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS/development";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, jovian-nixos, ... }: {
    nixosConfigurations.nix-steam-deck = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.willy = import ./home.nix;
        }
        jovian-nixos.nixosModules.default {
          jovian = {
            devices.steamdeck = {
              enable = true;
              autoUpdate = true;
            };
            steam.enable = true;
            steamos.useSteamOSConfig = true;
          };
        }
      ];
    };
  };
}
