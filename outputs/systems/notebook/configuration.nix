# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "notebook";
  networking.hostId = "6fd16644";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  # my own /etc/nixos/modules
  modules.base.enable = true;
  modules.bluetooth.enable = true;
  modules.cli.utils.enable = true;
  modules.desktop.tools.enable = true;
  modules.notebook.enable = true;
  # modules.desktop.sway.enable = true;
  modules.desktop.hyprland.enable = true;
  # modules.desktop.xorg.enable = true;
  # modules.desktop.gaming.enable = true;
  # modules.desktop.gaming.vr.enable = true;
  modules.desktop.sound.enable = true;
  modules.localdns.enable = true;
  modules.hardware.amd.enable = true;
  # modules.hardware.printer.samsung.enable = true;

  modules.input.japanese.enable = true;

  # enable CUPS and SANE for printing
  services.printing.enable = true;
  hardware.sane.enable = true;

  services.upower.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    insecure-registries = [
    ];
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-e4463f91-e6dd-4622-b677-ff3f4a4c362b".device = "/dev/disk/by-uuid/e4463f91-e6dd-4622-b677-ff3f4a4c362b";
  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;
  boot.initrd.luks.devices."luks-96244679-dafb-406c-936c-bf61bf2d6ddf".keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-e4463f91-e6dd-4622-b677-ff3f4a4c362b".keyFile = "/boot/crypto_keyfile.bin";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "video=eDP-1:1920x1080@60"
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernel.sysctl."vm.max_map_count" = "2147483642";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  nixpkgs.config.permittedInsecurePackages = [
    # "electron-25.9.0" # for obsidian on 2024-04-16
  ];

  networking.networkmanager.ensureProfiles.profiles = {
    "39C3" = {
      connection = {
        id = "39C3";
        type = "wifi";
      };
      wifi = {
        mode = "infrastructure";
        ssid = "39C3";
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-eap";
      };
      "802-1x" = {
        anonymous-identity = "39C3";
        eap = "ttls;";
        # identity = "39C3";
        # password = "39C3";
        identity = "outboundonly";
        password = "outboundonly";
        phase2-auth = "pap";
        altsubject-matches = "DNS:radius.c3noc.net";
        ca-cert = "${builtins.fetchurl {
          url = "https://letsencrypt.org/certs/isrgrootx1.pem";
          sha256 = "sha256:1la36n2f31j9s03v847ig6ny9lr875q3g7smnq33dcsmf2i5gd92";
        }}";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
    ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
}
