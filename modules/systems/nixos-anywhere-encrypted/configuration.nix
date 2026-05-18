# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  self,
  lib,
  ...
}: {
  flake.nixosConfigurations.nixos-anywhere-encrypted = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.base
      self.nixosModules.vmware-guest
      self.nixosModules.xorg
      self.nixosModules.nixos-anywhere-encrypted
      inputs.disko.nixosModules.disko
      {
        # Example to create a bios compatible gpt partition
        disko.devices = {
          disk.disk1 = {
            # sometimes this can be /dev/vda or indeed some other device
            device = lib.mkDefault "/dev/sda";
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                boot = {
                  name = "boot";
                  size = "1M";
                  type = "EF02";
                };
                esp = {
                  name = "ESP";
                  size = "500M";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [
                      "defaults"
                    ];
                  };
                };
                luks = {
                  size = "100%";
                  label = "luks";
                  content = {
                    type = "luks";
                    name = "cryptroot";
                    extraOpenArgs = [
                      "--allow-discards"
                      "--perf-no_read_workqueue"
                      "--perf-no_write_workqueue"
                    ];
                    content = {
                      type = "btrfs";
                      extraArgs = ["-L" "nixos" "-f"];
                      subvolumes = {
                        "/root" = {
                          mountpoint = "/";
                          mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                        };
                        "/home" = {
                          mountpoint = "/home";
                          mountOptions = ["subvol=home" "compress=zstd" "noatime"];
                        };
                        "/nix" = {
                          mountpoint = "/nix";
                          mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                        };
                        "/log" = {
                          mountpoint = "/var/log";
                          mountOptions = ["subvol=log" "compress=zstd" "noatime"];
                        };
                        "/swap" = {
                          mountpoint = "/swap";
                          swap.swapfile.size = "16G";
                        };
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
            self.homeModules.i3
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

  flake.nixosModules.nixos-anywhere-encrypted = {pkgs, ...}: {
    # boot.loader.systemd-boot.enable = true;
    boot = {
      kernelParams = [
        "resume_offset=533760"
      ];
      resumeDevice = "/dev/disk/by-label/nixos";
    };

    boot.loader.grub = {
      # no need to set devices, disko will add all devices that have a EF02 partition to the list already
      # devices = [ ];
      enable = true;
      # efiSupport = true;
      # efiInstallAsRemovable = true;
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;
    system.autoUpgrade.enable = true;

    # required for zfs support
    # networking.hostId = "621cba57";

    nixpkgs.config.allowUnfree = true;
    # nixpkgs-unstable.allowUnfree = true;
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    networking.hostName = "hacking-vm";

    services.openssh.enable = true;
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users = {
      mri = {
        isNormalUser = true;
        extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
      };

      root = {
        # change this to your ssh key
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSkWxGNSbQ6IqxdOf7fF5j0lCDKZMm3Dt+GEaUlnWVN mri@work-admin"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAORp9ktyNM2aPoGa4JeI0QLhxDhLmvSuEpUztpLovr root@nixos"
        ];
      };
    };

    fileSystems."/data/share" = {
      device = ".host:/share";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount" "nofail"];
    };

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;
    system.stateVersion = "24.05";
  };
}
