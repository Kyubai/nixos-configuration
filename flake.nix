{
  description = "kyubai's nixos configuration";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixpkgs-stable
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # disk partitioning
    # https://github.com/nix-community/disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
}
