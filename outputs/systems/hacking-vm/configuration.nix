# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  # my own /etc/nixos/modules
  modules.base.enable = true;
  modules.cli.utils.enable = true;
  modules.sec.utils.enable = true;
  modules.desktop.tools.enable = true;
  modules.work.enable = true;
  # modules.desktop.hyprland.enable = true;
  modules.desktop.xorg.enable = true;
  modules.vm.vmware.guest.enable = true;

  # boot.loader.systemd-boot.enable = true;

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    # enable = true;
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

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  fonts.fontconfig.defaultFonts.serif = [
    "Hack Nerd Font"
  ];

  fonts.fontconfig.defaultFonts.sansSerif = [
    "Hack Nerd Font"
  ];

  fonts.fontconfig.defaultFonts.monospace = [
    "Hack Nerd Font Mono"
  ];

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

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

  # Configure keymap in X11
  services.xserver.xkb.layout = "eu";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

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
}
