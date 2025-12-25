{
  description = "kyubai's nixos configuration";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # nixpkgs-stable
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    # nixpkgs-unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager
    # home-manager.url = "github:nix-community/home-manager/master";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # disk partitioning
    # https://github.com/nix-community/disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # NeoVim Framework
    # https://github.com/NotAShelf/nvf
    nvf.url = "github:notashelf/nvf/v0.8"; # pinned to 0.8 to fix deprecation error https://github.com/NotAShelf/nvf/issues/1172
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    # neovim nightly overlay
    # https://github.com/nix-community/neovim-nightly-overlay
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Obsidian nvim plugin for nvf
    # obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
  };
}
