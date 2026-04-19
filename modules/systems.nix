{ self, inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  flake.nixosConfigurations.desktop3950x = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      nixvim = inputs.nixvim;
      nixpkgs = inputs.nixpkgs;
    };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.desktop3950x-config
      self.nixosModules.i18n
      self.nixosModules.audio
      self.nixosModules.tailscale
      self.nixosModules.fonts
      self.nixosModules.docker
      self.nixosModules.no-sleep
      self.nixosModules.nix-settings
      self.nixosModules.desktop3950x-hardware
    ];
  };
}
