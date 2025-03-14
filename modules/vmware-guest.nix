{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfgGuest = config.modules.vm.vmware.guest;
  cfgFolder = config.modules.vm.vmware.sharedFolder;
in {
  options.modules.vm.vmware.guest.enable = mkEnableOption "vmware guest";
  options.modules.vm.vmware.sharedFolder.enable = mkEnableOption "vmware guest shared folder /data";

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

        #       services.xserver = {
        #         enable = true;
        #         # guest additions resize fix
        #         videoDrivers = ["vmware"];
        #       };

        # https://gist.github.com/mitchellh/3f8f4ff793c02f59d4c9576954f2632b
        # Mount the vmblock for drag-and-drop and copy-and-paste.
        #       systemd.mounts = [
        #         {
        #           description = "VMware vmblock fuse mount";
        #           documentation = ["https://github.com/vmware/open-vm-tools/blob/master/open-vm-tools/vmblock-fuse/design.txt"];
        #           before = ["vmware.service"];
        #           wants = ["vmware.service"];
        #           what = "${pkgs.open-vm-tools}/bin/vmware-vmblock-fuse";
        #           where = "/run/vmblock-fuse";
        #           # where = "/proc/fs/vmblock";
        #           type = "fuse";
        #           options = "subtype=vmware-vmblock,default_permissions,allow_other";
        #           wantedBy = ["multi-user.target"];
        #         }
        #       ];

        #       environment.etc."vmware-tools/tools.conf" = {
        #         mode = "0444";
        #         text = ''
        #           [resolutionKMS]
        #           enable=true
        #         '';
        #       };
      }
    )

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
