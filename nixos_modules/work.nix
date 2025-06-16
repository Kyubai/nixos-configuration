{
  config,
  lib,
  ...
}: let
  cfg = config.modules.work;
in {
  options.modules.work.enable = lib.mkEnableOption "enable settings required for work machines";

  config = lib.mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;
      settings = {
        listen-address = "::1,127.0.0.1";
        no-resolv = true; # ignore resolv.conf
        server = [
          "193.110.81.0" # dns0.eu
          # "2a0f:fc80::" # dns0.eu
          "185.253.5.0" # dns0.eu
          # "2a0f:fc81::" # dns0.eu
          "/react.intern/10.103.0.1"
        ];
      };
    };
  };
}
