{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgGuest = config.modules.vm.vmware.guest;
in {
  options.modules.vm.vmware.guest.enable = mkEnableOption "vmware guest";

  config = mkMerge [
    (
      mkIf cfgGuest.enable {
        virtualisation.vmware.guest = {
          enable = true;
          # headless = false;
        };
        environment.systemPackages = with pkgs; [
          xorg.xf86videovmware
          open-vm-tools
        ];
      }
    )
  ];
}
