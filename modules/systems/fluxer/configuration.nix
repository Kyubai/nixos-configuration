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

  flake.nixosModules.fluxer = {lib, pkgs, modulesPath, ...}: {
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
    networking.useDHCP = true;
    networking.firewall.enable = lib.mkForce false;

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

    systemd.services.fluxer-upgrade = {
      description = "Upgrade Fluxer (docker compose bundle)";
      after = ["docker.service" "network-online.target"];
      requires = ["docker.service"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer/fluxer-upgrade.sh";
        TimeoutStartSec = "45min";
      };
    };

    systemd.timers.fluxer-upgrade = {
      description = "Weekly Fluxer upgrade";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "Sun 06:00";
        Persistent = true;
      };
    };

    systemd.services.fluxer-reboot-check = {
      description = "Announce in Fluxer when the server needs a reboot";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer/reboot-check.sh";
      };
    };

    systemd.timers.fluxer-reboot-check = {
      description = "Daily check whether the server needs a reboot";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 09:00";
        Persistent = true;
      };
    };

    # Host-side helper services for the mod-bot monitor.
    # Scripts live in /srv (persisted); this config survives impermanence.
    systemd.tmpfiles.rules = [
      "d /run/fluxer-mod-bot 0755 root root -"
    ];

    systemd.services.fluxer-mod-bot-nft = {
      description = "Fluxer mod bot: load the nftables counter table";
      after = ["network-pre.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.nftables}/bin/nft -f /srv/fluxer-mod-bot/host/nft/fluxer-mod-bot.nft";
      };
    };

    systemd.services.fluxer-mod-bot-docker-stats = {
      description = "Fluxer mod bot: export container state";
      after = ["docker.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer-mod-bot/host/docker-stats-export";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = ["/run/fluxer-mod-bot"];
      };
    };
    systemd.timers.fluxer-mod-bot-docker-stats = {
      description = "Fluxer mod bot: export container state (timer)";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "10s";
        OnUnitActiveSec = "5s";
        AccuracySec = "1s";
      };
    };

    systemd.services.fluxer-mod-bot-nft-counters = {
      description = "Fluxer mod bot: export voice traffic counters";
      after = ["docker.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer-mod-bot/host/nft-counters";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = ["/run/fluxer-mod-bot"];
      };
    };
    systemd.timers.fluxer-mod-bot-nft-counters = {
      description = "Fluxer mod bot: export voice traffic counters (timer)";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "10s";
        OnUnitActiveSec = "2s";
        AccuracySec = "1s";
      };
    };

    systemd.services.fluxer-mod-bot-ping = {
      description = "Fluxer mod bot: ping targets";
      after = ["docker.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer-mod-bot/host/ping-export";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = ["/run/fluxer-mod-bot"];
      };
    };
    systemd.timers.fluxer-mod-bot-ping = {
      description = "Fluxer mod bot: ping targets (timer)";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "10s";
        OnUnitActiveSec = "30s";
        AccuracySec = "1s";
      };
    };

    systemd.services.fluxer-mod-bot-security = {
      description = "Fluxer mod bot: export SSH failures";
      after = ["docker.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer-mod-bot/host/security-export";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = ["/run/fluxer-mod-bot"];
      };
    };
    systemd.timers.fluxer-mod-bot-security = {
      description = "Fluxer mod bot: export SSH failures (timer)";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "10s";
        OnUnitActiveSec = "60s";
        AccuracySec = "1s";
      };
    };

    systemd.services.fluxer-mod-bot-geoip = {
      description = "Fluxer mod bot: update the DB-IP Lite Country database";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer-mod-bot/host/geoip-update";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = ["/srv/fluxer-mod-bot/data/geoip"];
      };
    };
    systemd.timers.fluxer-mod-bot-geoip = {
      description = "Fluxer mod bot: update the DB-IP Lite Country database (timer)";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-03 03:00:00";
        Persistent = true;
        RandomizedDelaySec = "10min";
      };
    };

    systemd.services.fluxer-mod-bot-storage = {
      description = "Fluxer mod bot: Fluxer storage breakdown";
      after = ["docker.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer-mod-bot/host/fluxer-storage-export";
        Nice = 19;
        IOSchedulingClass = "idle";
        TimeoutStartSec = "600";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = ["/run/fluxer-mod-bot"];
        ReadOnlyPaths = ["/srv/fluxer/volumes"];
      };
    };
    systemd.timers.fluxer-mod-bot-storage = {
      description = "Fluxer mod bot: Fluxer storage breakdown (timer)";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5min";
        OnCalendar = "hourly";
        RandomizedDelaySec = "300";
      };
    };

    systemd.services.fluxer-mod-bot-media = {
      description = "Fluxer mod bot: media bot state export";
      after = ["docker.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/srv/fluxer-mod-bot/host/media-bot-export";
        Nice = 19;
        IOSchedulingClass = "idle";
        TimeoutStartSec = "300";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ReadWritePaths = ["/run/fluxer-mod-bot"];
        ReadOnlyPaths = ["/srv/fluxer-media-bot" "/var/lib/docker/volumes/fluxer-media-bot_cache"];
      };
    };
    systemd.timers.fluxer-mod-bot-media = {
      description = "Fluxer mod bot: media bot state export (timer)";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "3min";
        OnCalendar = "*:0/15";
        RandomizedDelaySec = "60";
      };
    };

    system.stateVersion = "25.11";
  };
}
