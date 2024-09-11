{
  description = "kyubai's nixos configuration";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}
