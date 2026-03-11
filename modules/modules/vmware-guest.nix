{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.vmware-guest = {pkgs, ...}: {
    virtualisation.vmware.guest = {
      enable = true;
      # headless = false;
    };
    environment.systemPackages = with pkgs; [
      xorg.xf86videovmware
      open-vm-tools
    ];
  };
}
