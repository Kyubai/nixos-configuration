{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations."notebook" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.notebook
      self.nixosModules.amd
      self.nixosModules.base
      self.nixosModules.bluetooth
      self.nixosModules.cli-utils
      self.nixosModules.desktop
      self.nixosModules.hyprland
      self.nixosModules.japanese-input
      self.nixosModules.printing
      self.nixosModules.work
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          sharedModules = [
            self.homeModules.cli-utils
            self.homeModules.desktop
            self.homeModules.hyprland
            self.homeModules.work
          ];
          users.mri = {
            home.stateVersion = "23.11";
            wayland.windowManager.hyprland.settings = {
              monitor = "eDP-1, 1920x1080, 0x0, 1";
            };
          };
          users.root = {
            home.stateVersion = "23.11";
          };
        };
      }
    ];
  };

  flake.nixosModules.notebook = {pkgs, ...}: {
    networking.hostName = "notebook";
    networking.hostId = "6fd16644";
    networking.networkmanager.enable = true;

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/nvme0n1";
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.enableCryptodisk = true;

    boot.initrd.luks.devices."luks-e4463f91-e6dd-4622-b677-ff3f4a4c362b".device = "/dev/disk/by-uuid/e4463f91-e6dd-4622-b677-ff3f4a4c362b";
    boot.initrd.secrets = {"/boot/crypto_keyfile.bin" = null;};
    boot.initrd.luks.devices."luks-96244679-dafb-406c-936c-bf61bf2d6ddf".keyFile = "/boot/crypto_keyfile.bin";
    boot.initrd.luks.devices."luks-e4463f91-e6dd-4622-b677-ff3f4a4c362b".keyFile = "/boot/crypto_keyfile.bin";

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = ["video=eDP-1:1920x1080@60"];

    users.users.mri = {
      isNormalUser = true;
      extraGroups = [
        "dialout"
        "wheel"
        "video"
        "gamemode"
        "scanner"
        "lp"
        "libvirtd"
        "kvm"
      ];
    };

    system.stateVersion = "23.11";
  };
}
