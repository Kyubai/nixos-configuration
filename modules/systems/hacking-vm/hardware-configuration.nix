{
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosModules.hacking-vm = {
    boot.initrd.availableKernelModules = ["ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "ahci" "xhci_pci" "sd_mod" "sr_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];
    boot.loader.grub.enable = true;
    # boot.loader.grub.device = "/dev/sda";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
