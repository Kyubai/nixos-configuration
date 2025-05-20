{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfgNvim = config.modules.neovim;
in {
  options.modules.neovim.enable = lib.mkEnableOption "enable nvim text editor";

  config = lib.mkIf cfgNvim.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
        # package = inputs.neovim-overlay.packages.${pkgs.stdenv.system}.neovim;
        viAlias = false;
        vimAlias = true;

        options = {
          autoindent = true;
          shiftwidth = 0; # spaces used for autoindent 0 = use tabstop
          tabstop = 4; # visual spaces per tab
          softtabstop = 4; # visual spaces in tab on edit
          expandtab = true; # expand tabs to spaces
          shiftround = true; # align indent to next multiple value of shiftwidth. For its meaning see http://vim.1045645.n5.nabble.com/shiftround-option-td5712100.html
          tm = 100; # timeout in ms
          updatetime = 100; # The number of milliseconds till Cursor Hold event is fired
          wrap = false;
        };
        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };
        syntaxHighlighting = true;
        # TODO vim.maps
        # TODO vim.ui
        # TODO vim.utility
        utility = {
          surround.enable = true;
          oil-nvim.enable = true;
        };

        undoFile.enable = true;
        telescope.enable = true;
        snippets.luasnip.enable = true;
        statusline.lualine.enable = true;
        navigation.harpoon.enable = true;
        tabline.nvimBufferline.enable = true;
        terminal.toggleterm.enable = true;
        lsp = {
          enable = true;
          formatOnSave = true;
          inlayHints.enable = true;
          lightbulb.enable = true;
          lspconfig.enable = true;
          lspkind.enable = true;
        };
        languages = {
          enableDAP = true;
          enableFormat = true;
          enableTreesitter = true;
        };
        languages.nix = {
          enable = true;
          lsp.enable = true;
          # format.enable = true;
          # treesitter.enable = true;
        };
        languages.assembly = {
          enable = true;
          lsp.enable = true;
        };
        languages.bash = {
          enable = true;
          extraDiagnostics.enable = true;
          lsp.enable = true;
        };
        autocomplete.nvim-cmp.enable = true;

        autopairs.nvim-autopairs.enable = true;
        binds.hardtime-nvim.enable = true;
        binds.whichKey.enable = true;
        comments.comment-nvim.enable = true;
        debugger.nvim-dap.enable = true;
        filetree.neo-tree.enable = true;
        formatter.conform-nvim.enable = true;
        fzf-lua.enable = true;
        git.enable = true;
        git.git-conflict.enable = true;
        git.gitsigns.enable = true;
        # notes.obsidian.enable = true;
        notes.todo-comments.enable = true;
        notify.nvim-notify.enable = true;

        # extraPlugins = {
        #   harpoon = {
        #     package = pkgs.vimPlugins.harpoon;
        #     setup = "require('harpoon').setup {}";
        #   };
        # };
      };
    };
  };
}
