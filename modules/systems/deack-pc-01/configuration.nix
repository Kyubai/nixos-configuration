{
  inputs,
  self,
  pkgs,
  ...
}: {
  flake.nixosConfigurations."deack-pc-01" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.deack-pc-01
      self.nixosModules.agenix
      self.nixosModules.nas
      self.nixosModules.printing
      self.nixosModules.amd
      self.nixosModules.base
      self.nixosModules.gaming
      self.nixosModules.cli-utils
      self.nixosModules.dfir
      self.nixosModules.desktop
      self.nixosModules.niri
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          sharedModules = [
            self.homeModules.cli-utils
            self.homeModules.desktop
            self.homeModules.gaming
            self.homeModules.nas
            self.homeModules.niri
            self.homeModules.voice-input
          ];
          users.mri = {
            home.stateVersion = "23.11";
            wayland.windowManager.hyprland.settings.monitor = [
              "DP-1, 2560x1440, 2560x0, 1"
              "DP-3, 2560x1440, 0x0, 1"
            ];
            niri.outputConfig = ''
              output "DP-1" {
                  mode "2560x1440@180.000"
                  position x=2560 y=0
              }

              output "DP-3" {
                  mode "2560x1440@240.000"
                  position x=0 y=0
              }
            '';
          };
          users.root = {
            home.stateVersion = "23.11";
          };
        };
      }
    ];
  };

  flake.nixosModules.deack-pc-01 = {pkgs, ...}: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelParams = [
      "video=DP-1:1920x1080@144"
      "video=DP-3:2560x1440@240"
    ];
    boot.kernel.sysctl."vm.max_map_count" = "2147483642";
    boot.kernel.sysctl."split_lock_mitigate" = "0";

    # required for zfs support
    # networking.hostId = "621cba57";

    networking.hostName = "deack-pc-01";

    # CAKE shaper for Vodafone uplink — eliminates bufferbloat under SF6 / general load.
    # Bandwidth set to 95% of measured line speed (dl: 64 → 61 Mbit/s, ul: 5 → 4.8 Mbit/s).
    # Ingress shaping uses an IFB device to redirect inbound traffic through a CAKE qdisc.
    boot.kernelModules = [ "ifb" ];
    systemd.services."cake-shaper" = {
      description = "CAKE traffic shaper for Vodafone uplink";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      path = [ pkgs.iproute2 ];
      script = ''
        tc qdisc del dev enp4s0 root 2>/dev/null || true
        tc qdisc add dev enp4s0 root cake bandwidth 4800kbit besteffort

        ip link add ifb-wan type ifb 2>/dev/null || true
        ip link set ifb-wan up
        tc qdisc del dev enp4s0 ingress 2>/dev/null || true
        tc qdisc add dev enp4s0 handle ffff: ingress
        tc filter add dev enp4s0 parent ffff: matchall action mirred egress redirect dev ifb-wan
        tc qdisc del dev ifb-wan root 2>/dev/null || true
        tc qdisc add dev ifb-wan root cake bandwidth 61000kbit besteffort ingress
      '';
    };

    # Prefer DNS from enp4s0 (internal network) over enp12s0f3u3 (Vodafone USB).
    # The toggle-vodafone.sh script can override by running:
    #   nmcli connection modify enp12s0f3u3 ipv4.dns-priority 10 ipv6.dns-priority 10
    #   nmcli connection modify enp4s0 ipv4.dns-priority 200 ipv6.dns-priority 200
    networking.networkmanager.ensureProfiles.profiles = {
      enp4s0 = {
        connection = {
          id = "enp4s0";
          type = "ethernet";
          interface-name = "enp4s0";
          autoconnect-priority = "10";
        };
        ethernet = {};
        ipv4 = {
          method = "auto";
          dns-priority = "10";
          route-metric = "50";
        };
        ipv6.method = "disabled";
        proxy = {};
      };
      enp12s0f3u3 = {
        connection = {
          id = "enp12s0f3u3";
          type = "ethernet";
          interface-name = "enp12s0f3u3";
          autoconnect-priority = "10";
        };
        ethernet.mtu = "1400";
        ipv4 = {
          method = "auto";
          dns-priority = "200";
          route-metric = "200";
          never-default = "true";
        };
        ipv6.method = "disabled";
        proxy = {};
      };
    };
    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];

    users.users.mri = {
      isNormalUser = true;
      extraGroups = [
        "dialout"
        "wheel"
        "video"
        "gamemode"
        "scanner"
        "lp"
        "libvirtd" # for virt-manager
        "kvm" # for virt-manager
        "networkmanager"
      ];
    };

    system.stateVersion = "23.11";
  };
}
