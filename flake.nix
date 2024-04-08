{
  description = "kyubai's nixos configuration";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let inherit (self) outputs; in {

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations = {
      nixos-test = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # system = "x86_64-linux";
        modules = [./systems/nixos-test/configuration.nix];
      };
    };

    # homeConfigurations = {
    #   "full" = home-manager.lib.homeManagerConfiguration {
    #     modules = [./home-manager/full.nix];
    #   };
    # };
  };
}
