{ pkgs
, lib
, ...
}:

let
  luaConfig = import ./lua/config.nix;

in {

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = import ./init.vim;
    extraLuaConfig = ''
    ${luaConfig}
    '';
  };

  home.packages = with pkgs; [
    # lanuage servers
    rust-analyzer
    lua-language-server
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # TokyNight is my preffered colorscheme
    {
        plugin = pkgs.vimPlugins.tokyonight-nvim;
	    config = "colorscheme tokyonight-night";
    }

    # Telescope improves search
    pkgs.vimPlugins.telescope-nvim

    pkgs.vimPlugins.nvim-treesitter.withAllGrammars

    # inspect treesitter and some more functions
    pkgs.vimPlugins.playground

    # Harpoon provides navigation options
    pkgs.vimPlugins.harpoon

    # Improved undo function
    pkgs.vimPlugins.undotree

    # Git integration
    pkgs.vimPlugins.vim-fugitive

    # Language server
    # pkgs.vimPlugins.lsp-zero-nvim
    nvim-lspconfig
  ];

  home.shellAliases = {
    vim = "nvim";
  };
}
