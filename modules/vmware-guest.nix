{ pkgs, ... }:
{
  virtualisation.vmware.guest.enable = true;
  environment.systemPackages = [
    pkgs.open-vm-tools
  ];
  # services.vmware-user.enable = true;
}
