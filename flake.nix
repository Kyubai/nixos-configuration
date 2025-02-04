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

    # umu-launcher
    # https://github.com/Open-Wine-Components/umu-launcher
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
  };
}
