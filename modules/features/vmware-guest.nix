{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.vmware-guest = {pkgs, ...}: {
    imports = [
      self.nixosModules.clipboard-sync
    ];
    virtualisation.vmware.guest = {
      enable = true;
      headless = false;
    };

    boot.initrd.kernelModules = ["vmwgfx"];

    # Force VMware Tools KMS resolution support
    environment.etc."vmware-tools/tools.conf".text = ''
      [resolutionKMS]
      enable=true
    '';

    environment.systemPackages = with pkgs; [
      xorg.xf86videovmware
      open-vm-tools
    ];
  };
}
