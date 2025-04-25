{
  description = "kyubai's nixos configuration";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # nixpkgs-stable
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    # nixpkgs-unstable
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager
    # home-manager.url = "github:nix-community/home-manager/master";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # disk partitioning
    # https://github.com/nix-community/disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

#   outputs = {
#   nixpkgs,
#   disko,
#   nixos-facter-modules,
#   ...
#   }:
#   {
#   nixosConfigurations.hacking-vm = nixpkgs.lib.nixosSystem {
#   system = "x86_64-linux";
#   modules = [
#   disko.nixosModules.disko
#   ./outputs/systems/hacking-vm/configuration.nix
#   ./outputs/systems/hacking-vm/hardware-configuration.nix
#   ];
#   };
#   };
}
