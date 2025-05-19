{
  nixpkgs,
  # nixpkgs-unstable,
  disko,
  home-manager,
  ...
} @ inputs: let
  system = "x86_64-linux";
  # variables = nixpkgs.lib.importJSON ./secrets/variables.json;
  # pkgs = nixpkgs.legacyPackages.${system};
  #   pkgs-unstable = import nixpkgs-unstable {
  #     inherit system;
  #     config.allowUnfree = true;
  #   };
in {
  # Used with `nixos-rebuild --flake .#<hostname>`
  # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
  nixosConfigurations = {
    hacking-vm = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};

      # nixpkgs-unstable = import nixpkgs-unstable {
      # system = "x86_64-linux";
      # config = {
      # allowUnfree = true;
      # };
      # };
      # };
      modules = [
        ../modules
        disko.nixosModules.disko # required for nixos-anywhere
        ./systems/hacking-vm/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mri = import ../home-manager/hacking-vm.nix;
          home-manager.users.root = import ../home-manager/hacking-vm.nix;
        }
      ];
    };

    work2home = nixpkgs.lib.nixosSystem {
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
      # specialArgs = {inherit inputs;};
      # _module.args = {inherit inputs;};
      modules = [
        ../modules
        ./systems/work-admin/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mri = import ../home-manager/hacking-vm.nix;
          home-manager.users.root = import ../home-manager/hacking-vm.nix;
        }
      ];
    };

    deack-pc-01 = nixpkgs.lib.nixosSystem {
      # system = "x86_64-linux";
      # specialArgs = {inherit inputs;};
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
