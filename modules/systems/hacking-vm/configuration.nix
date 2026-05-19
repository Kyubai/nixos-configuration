{
  inputs,
  lib,
  self,
  ...
}: {
  flake.nixosConfigurations."hacking-vm" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.cli-utils
      self.nixosModules.desktop
      self.nixosModules.it-sec
      self.nixosModules.vmware-guest
      self.nixosModules.work
      self.nixosModules.hacking-vm
      self.nixosModules.sway
      inputs.disko.nixosModules.disko
      {
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
                  };
                };
                root = {
                  name = "root";
                  size = "100%";
                  content = {
                    type = "lvm_pv";
                    vg = "pool";
                  };
                };
              };
            };
          };
          lvm_vg = {
            pool = {
              type = "lvm_vg";
              lvs = {
                swap = {
                  size = "20%FREE";
                  content = {
                    type = "swap";
                  };
                };
                root = {
                  size = "100%FREE";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                    mountOptions = [
                      "defaults"
                    ];
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
            self.homeModules.sway
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

  flake.nixosModules.hacking-vm = {
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

    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    services.dbus.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    services.gnome.gnome-keyring.enable = true;

    # doesn't seem to work with Vivaldi yet
    # programs.chromium.extensions = [
    #   "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    # ];

    security.polkit.enable = true;
    security.rtkit.enable = true;

    # Enable CUPS to print documents.
    # services.printing.enable = true;

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

    # Shared folder
    fileSystems."/data/tools/personal" = {
      device = ".host:/tools_personal";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount" "nofail"];
    };

    fileSystems."/data/tools/at-yet" = {
      device = ".host:/tools_at-yet";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount" "nofail"];
    };

    fileSystems."/data/share" = {
      device = ".host:/share";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount" "nofail"];
    };

    fileSystems."/data/at-yet/vpn/react" = {
      device = ".host:/vpn_react";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount" "nofail"];
    };

    fileSystems."/data/obsidian_vaults/security_notes" = {
      device = ".host:/security_notes";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount" "nofail"];
    };

    # exported folders
    fileSystems."/export/tools/scripts" = {
      device = "/data/tools/personal/scripts";
      # device = "/home/mri/test";
      options = ["bind" "nofail"];
    };

    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "tools" = {
          "path" = "/export/tools";
          "browseable" = "yes";
          "read only" = "yes";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          # "force user" = "username";
          # "force group" = "groupname";
        };
      };
    };

    # squid proxy for internet forwarding
    services.squid = {
      enable = true;
      proxyPort = 3128;
      # configText = ''
      # http_access allow localhost
      # http_access deny all # Default deny
      # '';
    };
    networking.firewall.allowedTCPPorts = [3128];

    programs.proxychains.enable = true;
    programs.proxychains.proxies = {
      myproxy = {
        type = "socks5";
        host = "127.0.0.1";
        port = 9050;
      };
    };

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;
    system.stateVersion = "24.05";
  };
}
