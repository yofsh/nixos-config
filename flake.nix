{
  description = "System config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    walker.url = "github:abenz1267/walker";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }@inputs:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {

      nixpkgs.overlays = [ inputs.nur.overlay ];

      #TODO: load config based on host name?
      nixosConfigurations.ares = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/ares/configuration.nix ];
      };

      nixosConfigurations.athena = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/athena/configuration.nix ];
      };

      nixosConfigurations.hermes = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/hermes/configuration.nix ];
      };

      nixosConfigurations.medusa = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./hosts/medusa/configuration.nix ];
      };

      homeConfigurations.fobos = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        inherit pkgs;
        modules =
          [ ./home/default.nix { nixpkgs.overlays = [ nur.overlay ]; } ];
      };
    };
}
