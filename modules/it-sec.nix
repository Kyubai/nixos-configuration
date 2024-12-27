{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgSec = config.modules.sec.utils;
in {
  options.modules.sec.utils.enable = mkEnableOption "basic dfir and pentest utils";
  config = mkIf cfgSec.enable {
    environment.systemPackages = with pkgs; [
      nmap
      lnav
    ];
  };
}
