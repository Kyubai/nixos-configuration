{
  pkgs,
  lib,
  ...
}: let
  vimConfig = pkgs.callPackage ./vim/config.nix {};
  luaConfig = pkgs.callPackage ./lua/config.nix {};
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      ${vimConfig}
    '';
    extraLuaConfig = ''
      -- Allow imports from common locations for some packages.
      -- This is required for things like sumneko_lua to work.
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")
      ${luaConfig}
    '';
  };

  home.packages = with pkgs; [
    # lanuage servers
    rust-analyzer
    lua-language-server
    nixd

    alejandra # nix formatter
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # TokyNight is my preffered colorscheme
    tokyonight-nvim

    # Telescope improves search
    telescope-nvim

    # buffer like dir edit
    oil-nvim

    # inspect treesitter and some more functions
    nvim-treesitter.withAllGrammars
    playground

    # Harpoon provides navigation options
    harpoon

    # Improved undo function
    undotree

    # Git integration
    vim-fugitive

    # Language server
    nvim-lspconfig
    # completions
    nvim-cmp # completion engine
    luasnip # snippet engine
    cmp-buffer # buffer words
    cmp-path # paths
    cmp-nvim-lua # nvim lua api
    cmp-nvim-lsp # lsp
    cmp_luasnip # luasnip
    friendly-snippets # snippet collection
  ];

  home.shellAliases = {
    vim = "nvim";
  };
}
