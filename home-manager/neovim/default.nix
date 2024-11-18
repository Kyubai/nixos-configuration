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
    tokyonight-nvim # preffered colorscheme
    telescope-nvim # Telescope improves search
    oil-nvim # buffer like dir edit
    nvim-surround # improved movements for objects

    # inspect treesitter and some more functions
    nvim-treesitter.withAllGrammars
    playground

    harpoon # Harpoon provides navigation options
    undotree # Improved undo function
    vim-fugitive # Git integration

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
