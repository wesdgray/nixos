{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.nixos = let evalNixos = import (nixpkgs + "/nixos/lib/eval-config.nix"); in evalNixos { modules = [./configuration.nix]; system = null;};
  };
}
