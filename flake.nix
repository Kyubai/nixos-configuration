{
  description = "kyubai's nixos configuration";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # nixpkgs-stable
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    # nixpkgs-unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager
    # home-manager.url = "github:nix-community/home-manager/master";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # disk partitioning
    # https://github.com/nix-community/disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # NeoVim Framework
    # https://github.com/NotAShelf/nvf
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # neovim nightly overlay
    # https://github.com/nix-community/neovim-nightly-overlay
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Obsidian nvim plugin for nvf
    # obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
  };
}
