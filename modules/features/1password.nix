{ ... }:
{
  flake.nixosModules._1password =
    { ... }:
    {
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = [ "wes" ];
      };

      programs.ssh.extraConfig = ''
            Host *
        	    IdentityAgent ~/.1password/agent.sock
      '';

      security.pam.services._1password.u2fAuth = true;
    };
}
