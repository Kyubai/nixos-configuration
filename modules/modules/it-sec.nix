{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.it-sec = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      angle-grinder
      bintools
      flawz # tui cve
      fq # jq for binary
      imhex
      nmap
      jless # less for json
      lnav
      openfortivpn
      sqlite
      sshfs
      sshpass
      vmfs-tools
    ];
    security.krb5.enable = true;
    # security.krb5.settings.include = "/current_customer/.config/krb5.conf";
  };
}
