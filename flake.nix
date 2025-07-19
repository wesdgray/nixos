{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/4792576cb003c994bd7cc1edada3129def20b27d";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.nixos = let evalNixos = import (nixpkgs + "/nixos/lib/eval-config.nix"); in evalNixos { modules = [./configuration.nix]; system = null;};
  };
}
