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
  # modules.cli.utils.enable = true;
  # modules.sec.utils.enable = true;
  # modules.desktop.tools.enable = true;
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

  system.activationScripts.cloneEtcNixosRepo = {
    deps = ["etc"];
    text = ''
      set -euo pipefail

      target=/etc/nixos
      url=${lib.escapeShellArg "https://github.com/kyubai/nixos-configuration"}

      # If something made /etc/nixos a symlink (common when managed via /nix/store),
      # you can't have a writable git repo there.
      if [ -L "$target" ]; then
        echo "ERROR: $target is a symlink. Remove any environment.etc/tmpfiles rule that creates it."
        exit 1
      fi

      # Only clone if it's not already a git repo.
      if [ -d "$target" ]; then
        exit 1
      fi

      ${pkgs.git}/bin/git clone "$url" "$target"
    '';
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  system.stateVersion = "24.05";
}
