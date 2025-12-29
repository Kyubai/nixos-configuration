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

environment.persistence."/persist" = {
enable = true;
directories = [
"/etc/nixos"
];
};

services.openssh = {
enable = true;
settings = {
PasswordAuthentication = true;
PermitRootLogin = "yes";
};
};

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
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZtO1kbDva9UDEmvoxjuU+G0fDZlI2RjvNy1SN/iqgR mri@notebook"
      ];
    };
  };

  system.stateVersion = "25.11";
}
