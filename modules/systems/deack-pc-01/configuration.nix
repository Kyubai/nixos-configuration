{
  inputs,
  self,
  pkgs,
  ...
}: {
  flake.nixosConfigurations."deack-pc-01" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.deack-pc-01
      self.nixosModules.amd
      self.nixosModules.base
      self.nixosModules.gaming
      self.nixosModules.cli-utils
      self.nixosModules.desktop
      self.nixosModules.hyprland
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          sharedModules = [
            self.homeModules.cli-utils
            self.homeModules.hyprland
          ];
          users.mri = {
            home.stateVersion = "23.11";
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

    system.stateVersion = "23.11";
  };
}
