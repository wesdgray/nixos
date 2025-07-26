{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = let evalNixos = import (nixpkgs + "/nixos/lib/eval-config.nix"); in evalNixos { 
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
      system = null;
    };
  };
}
