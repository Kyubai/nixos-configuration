{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations."work-admin" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.cli-utils
      self.nixosModules.desktop
      self.nixosModules.it-sec
      self.nixosModules.vmware-guest
      self.nixosModules.work
      self.nixosModules.work-admin
      self.nixosModules.xorg
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          sharedModules = [
            self.homeModules.cli-utils
            self.homeModules.i3
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

  flake.nixosModules.work-admin = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;

    # required for zfs support
    networking.hostId = "621cba57";

    networking.hostName = "work-admin";

    fileSystems."/data/tools/at-yet" = {
      device = ".host:/data_tools";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
    };

    fileSystems."/data/tools/personal" = {
      device = ".host:/data_personal";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
    };

    fileSystems."/data/at-yet" = {
      device = ".host:/data_work";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
    };

    fileSystems."/data/share" = {
      device = ".host:/share";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
    };

    fileSystems."/data/obsidian_vaults" = {
      device = ".host:/obsidian_vaults";
      fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
      options = ["uid=1000" "gid=1000" "umask=0033" "allow_other" "auto_unmount"];
    };

    users.users.mri = {
      isNormalUser = true;
      extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    };

    system.stateVersion = "23.11";
  };
}
