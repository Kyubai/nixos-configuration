{ pkgs, ... }:
{
  services.printing = {
    enable = true;
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
  hardware.sane.enable = true;
}
