{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.work-admin = {
    boot.initrd.availableKernelModules = ["ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "ahci" "xhci_pci" "sd_mod" "sr_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/d6b8caad-3a86-4cba-b596-780879698ba2";
      fsType = "ext4";
    };

    swapDevices = [];

    networking.useDHCP = true;
    networking.dhcpcd.persistent = true;

    nixpkgs.hostPlatform = "x86_64-linux";

    # do not change
    system.stateVersion = "23.11";
  };
}
