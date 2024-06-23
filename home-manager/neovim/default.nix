{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = import ./init.vim;
    extraLuaConfig = import ./init.lua;
  };

  programs.neovim.plugins = [
    # TokyNight is my preffered colorscheme
    {
        plugin = pkgs.vimPlugins.tokyonight-nvim;
	    config = "colorscheme tokyonight-night";
    }

    # Telescope improves search
    pkgs.vimPlugins.telescope-nvim

    pkgs.vimPlugins.nvim-treesitter.withAllGrammars

    # Harpoon provides navigation options
    pkgs.vimPlugins.harpoon

    # Improved undo function
    pkgs.vimPlugins.undotree

    # Git integration
    pkgs.vimPlugins.vim-fugitive
  ];

  home.shellAliases = {
    vim = "nvim";
  };
}
