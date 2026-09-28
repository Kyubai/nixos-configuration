{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations."server" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.base
      self.nixosModules.cli-utils
      self.nixosModules.server
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

  flake.nixosModules.server = {
    imports = [
      ./hardware-configuration.nix
    ];

    networking.hostName = "server";

    boot.loader.grub.enable = true;
    boot.loader.grub.devices = ["/dev/sda"];

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
        extraGroups = ["wheel"];
      };

      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSkWxGNSbQ6IqxdOf7fF5j0lCDKZMm3Dt+GEaUlnWVN mri@work-admin"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAORp9ktyNM2aPoGa4JeI0QLhxDhLmvSuEpUztpLovr root@nixos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZtO1kbDva9UDEmvoxjuU+G0fDZlI2RjvNy1SN/iqgR mri@notebook"
        ];
      };
    };

    system.stateVersion = "25.11";
  };
}
