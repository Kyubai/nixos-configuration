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
    };
    environment.systemPackages = with pkgs; [
      xorg.xf86videovmware
      open-vm-tools
    ];
  };
}
