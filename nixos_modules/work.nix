{
  config,
  lib,
  ...
}: let
  cfg = config.modules.localdns;
in {
  options.modules.localdns.enable = lib.mkEnableOption "enable local dns server for various vpns";

  config = lib.mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;
      settings = {
        listen-address = "::1,127.0.0.1";
        no-resolv = true; # ignore resolv.conf
        log-queries = true;
        log-facility = "/var/log/dnsmasq.log";
        server = [
          "185.222.222.222" # dns.sb
          "45.11.45.11" # dns.sb
          # "193.110.81.0" # dns0.eu
          # "2a0f:fc80::" # dns0.eu
          # "185.253.5.0" # dns0.eu
          # "2a0f:fc81::" # dns0.eu
          "/react.intern/10.103.0.1"
          "/addyet.intern/10.10.0.2" # Hacker DMZ
          "/authentication.add-yet.de/10.10.0.2" # Hacker DMZ
          "/addyet.intern/192.168.250.5" # addyet.intern
          "/intern.verriegelt.net/10.105.201.1"
        ];
      };
    };
  };
}
