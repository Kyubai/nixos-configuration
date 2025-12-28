# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];


  networking.hostName = "server";
  # networking.hostId = "6fd16622";

  # my own /etc/nixos/modules
modules.base.enable = true;
  modules.cli.utils.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    insecure-registries = [
    ];
  };

  # boot config
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["/dev/sda"];

  system.stateVersion = "25.11";
}
