{
  config,
  lib,
  ...
}:
with lib; let
  cfgGuest = config.modules.vm.vmware.guest;
  cfgFolder = config.modules.vm.vmware.sharedFolder;
in {
  options.modules.vm.vmware.guest.enable = mkEnableOption "vmware guest";
  options.modules.vm.vmware.sharedFolder.enable = mkEnableOption "vmware guest shared folder /data";

  config = mkMerge [
    (mkIf cfgGuest.enable {
      virtualisation.vmware.guest.enable = true;
    })

    (mkIf cfgFolder.enable {
      # this mounts the sharedFolder /data
      fileSystems."/data" = {
        device = ".host:/data";
        fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
        options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
      };
    })
  ];
}
