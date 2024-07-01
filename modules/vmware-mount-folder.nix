{ ... }:
{
  fileSystems."/data" = {
    device = ".host:/data";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
  };
}
