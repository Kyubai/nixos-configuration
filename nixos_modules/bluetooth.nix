{
  config,
  lib,
  ...
}:
let
  cfgBluetooth = config.modules.bluetooth;
in {
  options.modules.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf cfgBluetooth.enable {
    # https://nixos.wiki/wiki/Bluetooth
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    services.blueman.enable = true;
  };
}
