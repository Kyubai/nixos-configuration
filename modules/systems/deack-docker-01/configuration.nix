{
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosConfigurations."deack-docker-01" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.deack-docker-01
      self.nixosModules.base
      self.nixosModules.cli-utils
      self.nixosModules.agenix
      self.nixosModules.impermanence
      self.nixosModules.srv-compose
      self.nixosModules.nas
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

  flake.nixosModules.deack-docker-01 = {pkgs, lib, modulesPath, ...}: {
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

    networking.hostName = "deack-docker-01";
    networking.networkmanager.enable = true;

    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "no";

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
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJaOvQm6DCDl+ytVcGr7sFtJZINapQynYASlnlf090nV mri@deack-pc-01"
      ];
    };

    services.restic.backups.verriegelt.timerConfig = lib.mkForce {
      OnCalendar = "05:30:00";
      Persistent = true;
    };

    systemd.tmpfiles.rules = ["d /mnt/media 0755 root root -"];

    fileSystems."/mnt/media" = {
      device = "//deack-nas-01.intern.verriegelt.net/media";
      fsType = "cifs";
      options = [
        "credentials=/run/agenix/nas-credentials"
        "vers=3.0"
        "noperm"
        "file_mode=0777"
        "dir_mode=0777"
        "x-systemd.automount"
        "noauto"
        "_netdev"
      ];
    };

    system.stateVersion = "25.11";
  };
}
