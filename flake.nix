{
  description = "kyubai's nixos configuration";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let inherit (self) outputs; in {

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations = {
      hacking-vm = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # system = "x86_64-linux";
        modules = [
	./systems/hacking-vm/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mri = import ./home-manager/default.nix;
          home-manager.users.root = import ./home-manager/default.nix;
        }
	];
      };

      nixos-test-virtmanager = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # system = "x86_64-linux";
        modules = [
	./systems/nixos-test-virtmanager/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mri = import ./home-manager/default.nix;
          home-manager.users.root = import ./home-manager/default.nix;
        }
	];
      };

    deack-pc-01 = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      # system = "x86_64-linux";
      modules = [
	./systems/deack-pc-01/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mri = import ./home-manager/default.nix;
          home-manager.users.root = import ./home-manager/default.nix;
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
	  inherit inputs outputs;
	};
        modules = [
	  ./home-manager/mri.nix
	];
      };
      "root" = home-manager.lib.homeManagerConfiguration {
	pkgs = nixpkgs.legacyPackages.x86_64-linux;
	extraSpecialArgs = {
	  inherit inputs outputs;
	};
        modules = [
	  ./home-manager/root.nix
	];
      };
    };
  };
}
