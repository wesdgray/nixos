{
  flake.nixosModules.tailscale = {
    services.tailscale = {
      enable = true;
      extraUpFlags = [ "--ssh=false" ];
      extraSetFlags = [ "--ssh=false" ];
    };
  };
}
