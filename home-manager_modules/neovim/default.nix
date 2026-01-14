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
        # package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.system}.neovim;
        viAlias = false;
        vimAlias = true;

        # searching
        hideSearchHighlight = true;
        searchCase = "smart";

        options = {
          # Indenting
          autoindent = true; # use indent from last line
          smarttab = true; # use shiftwidth for identation at start of line
          shiftround = true; # align indent to next multiple value of shiftwidth. For its meaning see http://vim.1045645.n5.nabble.com/shiftround-option-td5712100.html

          # Tab Settings
          # https://gist.github.com/LunarLambda/4c444238fb364509b72cfb891979f1dd
          shiftwidth = 2; # spaces used for autoindent 0 = use tabstop
          tabstop = 4; # visual spaces per tab
          softtabstop = -1; # spaces inserted on <Tab> and <Backspace>, -1 = use shiftwidth
          expandtab = true; # expand tabs to spaces

          tm = 500; # timeout in ms
          updatetime = 50; # The number of milliseconds till Cursor Hold event is fired
          wrap = false;
        };
        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };
        # syntaxHighlighting = true;
        # TODO vim.maps
        maps = {
          normalVisualOp = {
            "H" = {
              action = "^";
              desc = "Go to start of line";
            };
            "L" = {
              action = "g_";
              desc = "Go to end of line";
            };
            "<C-c>" = {
              action = "\"+y";
              desc = "Copy to clipboard";
            };
            "<leader>p" = {
              action = "+p";
              desc = "Paste from clipboard";
            };
            "<leader>P" = {
              action = "+P";
              desc = "Paste from clipboard";
            };
            "<leader>d" = {
              action = "\"_d";
              desc = "delete without yanking";
            };
          };
          normal = {
            "J" = {
              action = "mzJ`z";
              desc = "Merge rows without moving the cursor";
            };
            "<C-d>" = {
              action = "<C-d>zz";
              desc = "Move screen while keeping the cursor centered";
            };
            "<C-u>" = {
              action = "<C-u>zz";
              desc = "Move screen while keeping the cursor centered";
            };
            "n" = {
              action = "nzzzv";
              desc = "search match while keeping the cursor centered";
            };
            "N" = {
              action = "Nzzzv";
              desc = "search match while keeping the cursor centered";
            };
            "Q" = {
              action = "function() vim.lsp.buf.format() end";
              desc = "Format buffer with lsp";
              lua = true;
            };
            "<leader>s" = {
              action = ":%s,\\<<C-r><C-w>\\>,<C-r><C-w>,gI<Left><Left><Left>";
              desc = "search and replace current word";
            };
            "<leader>x" = {
              action = "<cmd>!chmod +x %<CR>";
              desc = "make current file executable";
              silent = true;
            };
            "-" = {
              action = "<CMD>Oil<CR>";
              desc = "Open parent directory";
            };
            "<leader>gs" = {
              action = "vim.cmd.Git";
              desc = "Open fuGitive";
              lua = true;
            };
          };
          visual = {
            "J" = {
              action = ":m '>+1<CR>gv=gv";
              desc = "move highlighted lines";
            };
            "K" = {
              action = ":m '<-2<CR>gv=gv";
              desc = "move highlighted lines";
            };
          };
          insert = {
            "jk" = {
              action = "<Esc>";
              desc = "fast quite to normal mode";
              nowait = true;
            };
          };
        };
        # TODO vim.ui
        # TODO vim.utility
        utility = {
          surround = {
            enable = true;
            useVendoredKeybindings = false;
          };
          oil-nvim.enable = true;
        };

        navigation.harpoon.enable = true;
        snippets.luasnip.enable = true;
        statusline.lualine.enable = true;
        tabline.nvimBufferline.enable = true;
        telescope.enable = true;
        terminal.toggleterm.enable = true;
        undoFile.enable = true;
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
        languages.rust = {
          enable = true;
          lsp.enable = true;
        };
        assistant.avante-nvim = {
          enable = true;
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
      };
    };
  };
}
