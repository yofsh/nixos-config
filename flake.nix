{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }@inputs:


    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {


    nixpkgs.overlays = [
      inputs.nur.overlay
    ];

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [./nixos/configuration.nix];
    };

    homeConfigurations.fobos = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ 
        ./home.nix
        {nixpkgs.overlays = [nur.overlay];}

      ];
    };
  };
}
