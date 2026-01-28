{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgSec = config.modules.sec.utils;
  # freerdp_custom = pkgs.lib.overrideDerivation (pkgs.freerdp3) (old: {NIX_CFLAGS_COMPILE = " -D_WITH_KRB5=ON";});
in {
  options.modules.sec.utils.enable = mkEnableOption "basic dfir and pentest utils";
  config = mkIf cfgSec.enable {
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
      squid # for internet forwading via ssh
      sqlite
      sshfs
      sshpass
      vmfs-tools
    ];
    security.krb5.enable = true;
    # security.krb5.settings.include = "/current_customer/.config/krb5.conf";
  };
}
