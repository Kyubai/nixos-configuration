{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.printing = {pkgs, ...}: {
    # enable samsung printer drivers

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
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
    services.ipp-usb.enable = true;
  };
}
