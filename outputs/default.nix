{
  nixpkgs,
  disko,
  home-manager,
  ...
} @ inputs: {
  # Used with `nixos-rebuild --flake .#<hostname>`
  # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
  nixosConfigurations = {
    hacking-vm = nixpkgs.lib.nixosSystem {
      # specialArgs = {inherit inputs outputs;};
      system = "x86_64-linux";
      modules = [
        # ../modules
        disko.nixosModules.disko
        ./systems/hacking-vm/configuration.nix
        # home-manager.nixosModules.home-manager
        #         {
        #           home-manager.useGlobalPkgs = true;
        #           home-manager.useUserPackages = true;
        #           home-manager.users.mri = import ../home-manager/hacking-vm.nix;
        #           home-manager.users.root = import ../home-manager/hacking-vm.nix;
        #         }
      ];
    };

    surf01 = nixpkgs.lib.nixosSystem {
      # specialArgs = {inherit inputs outputs;};
      # system = "x86_64-linux";
      modules = [
        ../modules
        ./systems/surf01/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mri = import ../home-manager/hacking-vm.nix;
          home-manager.users.root = import ../home-manager/hacking-vm.nix;
        }
      ];
    };

    work-admin = nixpkgs.lib.nixosSystem {
      # system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      # _module.args = {inherit inputs;};
      modules = [
        ../modules
        ./systems/work-admin/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mri = import ../home-manager/mri.nix;
          home-manager.users.root = import ../home-manager/root.nix;
        }
      ];
    };

    deack-pc-01 = nixpkgs.lib.nixosSystem {
      # system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      # _module.args = {inherit inputs;};
      modules = [
        ../modules
        ./systems/deack-pc-01/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mri = import ../home-manager/mri.nix;
          home-manager.users.root = import ../home-manager/root.nix;
        }
      ];
    };
  };

  # Standalone home-manager configuration entrypoint
  # Available through 'home-manager --flake .#your-username@your-hostname'
  homeConfigurations = {
    "mri" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        # inherit inputs outputs;
      };
      modules = [
        ../home-manager/mri.nix
      ];
    };
    "root" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        # inherit inputs outputs;
      };
      modules = [
        ../home-manager/root.nix
      ];
    };
  };
}
