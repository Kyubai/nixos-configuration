{
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosConfigurations."fluxer" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.fluxer
      self.nixosModules.base
      self.nixosModules.cli-utils
      self.nixosModules.agenix
      self.nixosModules.impermanence
      self.nixosModules.srv-compose
      self.nixosModules.restic-bonfire
      inputs.disko.nixosModules.disko
      {
        disko.devices = {
          disk.main = {
            device = "/dev/sda";
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                boot = {
                  name = "boot";
                  size = "1M";
                  type = "EF02";
                };
                root = {
                  name = "root";
                  size = "100%";
                  content = {
                    type = "btrfs";
                    extraArgs = ["-L" "nixos" "-f"];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                      };
                      "/persist" = {
                        mountpoint = "/persist";
                        mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                      };
                    };
                  };
                };
              };
            };
          };
        };
      }
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          sharedModules = [
            self.homeModules.cli-utils
          ];
          users.mri = {
            home.stateVersion = "25.11";
          };
          users.root = {
            home.stateVersion = "25.11";
          };
        };
      }
    ];
  };

  flake.nixosModules.fluxer = {lib, modulesPath, ...}: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];

    boot.loader.grub.enable = true;

    boot.supportedFilesystems = ["btrfs"];
    boot.initrd.systemd.enable = false;

    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /mnt
      mount -t btrfs /dev/disk/by-label/nixos /mnt
      btrfs subvolume delete /mnt/root
      btrfs subvolume create /mnt/root
      sync
      umount /mnt
    '';

    fileSystems."/persist".neededForBoot = true;

    age.identityPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;
    nix.settings.trusted-users = ["mri"];

    networking.hostName = "fluxer";
    networking.useDHCP = false;
    networking.interfaces.ens18.useDHCP = true;

    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "yes";

    security.sudo.extraRules = [
      {
        users = ["mri"];
        commands = [{
          command = "ALL";
          options = ["NOPASSWD"];
        }];
      }
    ];

    users.users.mri = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJaOvQm6DCDl+ytVcGr7sFtJZINapQynYASlnlf090nV mri@deack-pc-01"
      ];
    };

    system.stateVersion = "25.11";
  };
}
