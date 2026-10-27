{
  inputs,
  self,
  pkgs,
  ...
}: {
  flake.nixosConfigurations."deack-dmz-01" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.deack-dmz-01
      self.nixosModules.base
      self.nixosModules.cli-utils
      self.nixosModules.agenix
      self.nixosModules.impermanence
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          sharedModules = [
            self.homeModules.cli-utils
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

  flake.nixosModules.deack-dmz-01 = {pkgs, ...}: {
    # Boot loader configuration for GRUB
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";

    # Nix settings
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;

    # Hostname
    networking.hostName = "deack-dmz-01";

    # Enable NetworkManager for network configuration
    networking.networkmanager.enable = true;
    networking.networkmanager.ensureProfiles.profiles = {
      ens18 = {
        connection = {
          id = "ens18";
          type = "ethernet";
          interface-name = "ens18";
        };
        ipv4.method = "auto";
        ipv6.method = "ignore";
      };
    };

    # Enable SSH for remote access (essential for DMZ server)
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "no";

    security.sudo.extraRules = [
      {
        users = ["mri"];
        commands = [{
          command = "ALL";
          options = ["NOPASSWD"];
        }];
      }
    ];

    # User configuration
    users.users.mri = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable sudo
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJaOvQm6DCDl+ytVcGr7sFtJZINapQynYASlnlf090nV mri@deack-pc-01"
      ];
    };

    # System state version
    system.stateVersion = "25.11";
  };
}
