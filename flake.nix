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
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, nur, sops-nix, ... }@inputs:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {

      nixpkgs.overlays = [ inputs.nur.overlay ];

      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/iso/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.fobos = import ./home/default.nix;
          }
        ];
      };

      #TODO: load config based on host name?
      nixosConfigurations.ares = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/ares/configuration.nix ];
      };

      nixosConfigurations.athena = nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [ ./hosts/athena/configuration.nix sops-nix.nixosModules.sops ];
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
