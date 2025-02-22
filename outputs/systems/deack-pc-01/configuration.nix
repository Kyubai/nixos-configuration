# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    # ../../../modules/development.nix
  ];

  networking.hostName = "deack-pc-01";
  networking.hostId = "6fd16622";

  # my own /etc/nixos/modules
  modules.base.enable = true;
  modules.bluetooth.enable = true;
  modules.cli.utils.enable = true;
  modules.desktop.tools.enable = true;
  # modules.desktop.sway.enable = true;
  modules.desktop.hyprland.enable = true;
  # modules.desktop.xorg.enable = true;
  modules.desktop.gaming.enable = true;
  modules.desktop.sound.enable = true;
  modules.hardware.amd.enable = true;
  modules.hardware.printer.samsung.enable = true;

  modules.input.japanese.enable = true;

  # enable CUPS and SANE for printing
  services.printing.enable = true;
  hardware.sane.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    insecure-registries = [
    ];
  };

  # boot config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "video=DP-3:1920x1080@144"
    "video=DP-1:2560x1440@240"
  ];
  boot.kernel.sysctl."vm.max_map_count" = "2147483642";

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

  services.syncthing = {
    enable = true;
    user = "mri";
    dataDir = "/srv/syncthing";
  };

  # fix dynamically linked libraries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add missing dynamic libraries
    libglvnd
    libGL
    zlib
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mri = {
    isNormalUser = true;
    extraGroups = [
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
