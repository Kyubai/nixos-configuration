# Edit this configuration file to define what should be installed on
#internintern your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    # systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };
  boot.initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/2e1c4254-fea8-4b8f-b37c-a883b037a628";

  # my own /etc/nixos/modules
  modules.base.enable = true;
  modules.cli.utils.enable = true;
  modules.sec.utils.enable = true;
  modules.desktop.tools.enable = true;
  # modules.desktop.hyprland.enable = true;
  modules.desktop.xorg.enable = true;
  modules.vm.vmware.guest.enable = true;
  # modules.work.enable = true;

  # required for zfs support
  # networking.hostId = "621cba57";

  nixpkgs.config.allowUnfree = true;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostName = "work2home";

  services.dnsmasq = {
    enable = true;
    settings = {
      listen-address = "::1,127.0.0.1";
      no-resolv = true; # ignore resolv.conf
      log-queries = true;
      log-facility = "/var/log/dnsmasq.log";
      server = [
        "185.222.222.222" # dns.sb
        "45.11.45.11" # dns.sb
        # "193.110.81.0" # dns0.eu
        # "2a0f:fc80::" # dns0.eu
        # "185.253.5.0" # dns0.eu
        # "2a0f:fc81::" # dns0.eu
        "/addyet.intern/10.10.0.2" # Hacker DMZ
        "/addyet.intern/192.168.250.5" # addyet.intern
        "/verriegelt.net/10.105.201.1"
        "/intern.verriegelt.net/10.105.201.1"
      ];
    };
  };

  fileSystems."/data/tools/personal" = {
    device = ".host:/data_personal";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
  };

  fileSystems."/data/share" = {
    device = ".host:/share";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mri = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
