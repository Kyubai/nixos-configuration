{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  disko,
  nvf,
  ...
} @ inputs: let
  system = "x86_64-linux";
  unstableOverlay = (
    final: prev: let
      u = nixpkgs-unstable.legacyPackages.${system};
    in {
      # Pull both to avoid wlroots mismatches
      # floorp = u.floorp-bin;
      floorp-bin = u.floorp-bin; # unstable version is more up2date, which might be required for plugins
      floorp-bin-unwrapped = u.floorp-bin-unwrapped; # unstable version is more up2date, which might be required for plugins
      hyprland = u.hyprland; # unstable version is more up2date, which might fix bugs
      wlroots-hyprland = u.wlroots-hyprland; # wlroots needs to match hyprland version
    }
  );
  unstableModule = {...}: {
    nixpkgs.overlays = [unstableOverlay];
  };
  # variables = nixpkgs.lib.importJSON ./secrets/variables.json;
  # };
in {
  # Used with `nixos-rebuild --flake .#<hostname>`
  # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
  homeManagerModules.default = ../home-manager_modules;
  nixosConfigurations = {
    hacking-vm = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        unstableModule
        ../nixos_modules
        disko.nixosModules.disko # required for nixos-anywhere
        ./systems/hacking-vm/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.sharedModules = [
            inputs.self.outputs.homeManagerModules.default
            inputs.nvf.homeManagerModules.default
          ];

          home-manager.users.mri.imports = [
            ./home-manager/systems/hacking-vm.nix
          ];
          home-manager.users.root.imports = [
            ./home-manager/systems/hacking-vm.nix
          ];
        }
      ];
    };

    nixos-anywhere-minimal = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ../nixos_modules
        disko.nixosModules.disko # required for nixos-anywhere
        ./systems/nixos-anywhere-minimal/configuration.nix
      ];
    };

    nixos-anywhere-encrypted = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ../nixos_modules
        disko.nixosModules.disko # required for nixos-anywhere
        ./systems/nixos-anywhere-encrypted/configuration.nix
      ];
    };

    work2home = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        ../nixos_modules
        ./systems/work2home/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.sharedModules = [
            inputs.self.outputs.homeManagerModules.default
            inputs.nvf.homeManagerModules.default
          ];

          home-manager.users.mri.imports = [
            ./home-manager/systems/hacking-vm.nix
          ];
          home-manager.users.root.imports = [
            ./home-manager/systems/hacking-vm.nix
          ];
        }
      ];
    };

    work-admin = nixpkgs.lib.nixosSystem {
      # system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      # _module.args = {inherit inputs;};
      modules = [
        unstableModule
        ../nixos_modules
        nvf.nixosModules.default
        ./systems/work-admin/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [
            inputs.self.outputs.homeManagerModules.default
            inputs.nvf.homeManagerModules.default
          ];
          home-manager.users.mri.imports = [
            ./home-manager/systems/hacking-vm.nix
          ];
          home-manager.users.root.imports = [
            ./home-manager/systems/hacking-vm.nix
          ];
        }
      ];
    };

    deack-pc-01 = nixpkgs.lib.nixosSystem {
      # system = "x86_64-linux";
      # specialArgs = {inherit inputs;};
      # _module.args = {inherit inputs;};
      modules = [
        unstableModule
        ../nixos_modules
        nvf.nixosModules.default
        ./systems/deack-pc-01/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [
            inputs.self.outputs.homeManagerModules.default
            inputs.nvf.homeManagerModules.default
            ./home-manager/systems/gaming-pc.nix
          ];
          home-manager.users.mri.imports = [
            ./home-manager/mri.nix
          ];
          home-manager.users.root.imports = [
            ./home-manager/mri.nix
          ];
        }
      ];
    };
    notebook = nixpkgs.lib.nixosSystem {
      # system = "x86_64-linux";
      # specialArgs = {inherit inputs;};
      # _module.args = {inherit inputs;};
      modules = [
        ../nixos_modules
        nvf.nixosModules.default
        ./systems/notebook/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [
            inputs.self.outputs.homeManagerModules.default
            inputs.nvf.homeManagerModules.default
            ./home-manager/systems/notebook.nix
          ];
          home-manager.users.mri.imports = [
            ./home-manager/mri.nix
          ];
          home-manager.users.root.imports = [
            ./home-manager/mri.nix
          ];
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
        ./home-manager/mri.nix
      ];
    };
    "root" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        # inherit inputs outputs;
      };
      modules = [
        ./home-manager/root.nix
      ];
    };
    "ssh-utils" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [
        inputs.self.outputs.homeManagerModules.default
        inputs.nvf.homeManagerModules.default
        ./home-manager/ssh-utils.nix
        ./home-manager/mri.nix
      ];
    };
  };
}
