{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfgSamsung = config.modules.hardware.printer.samsung;
in {
  options.modules.hardware.printer.samsung = {
    enable = mkEnableOption "Samsung printer";
  };

  # enable samsung printer drivers
  config = mkIf cfgSamsung.enable {
    services.printing = {
      drivers = with pkgs; [
        # gutenprint
        # gutenprintBin
        # hplip
        # hplipWithPlugin
        samsung-unified-linux-driver
        samsung-unified-linux-driver_1_00_37
        samsung-unified-linux-driver_1_00_36
        # splix
      ];
    };
  };
}
