vim.cmd "syntax on"

-- change leader key
vim.g.mapleader = " "

vim.cmd "colorscheme tokyonight-night"

-- dynamic line-numbers
vim.cmd "set number relativenumber"

-- disable beep
vim.cmd "set belloff=all"

vim.opt.completeopt = {'menu', 'menuone', 'noselect' }
-- set showmatch
-- set hlsearch

-- Ignore case in general, but become case-sensitive when uppercase is present
vim.cmd "set ignorecase smartcase"

-- set autoindent
-- set smartindent

-- Tab settings
vim.cmd "set tabstop=4"       -- visual spaces per tab
vim.cmd "set softtabstop=4"   -- spaces in tab on edit
vim.cmd "set shiftwidth=4"    -- spaces used for autoident
vim.cmd "set expandtab"       -- expand tab to spaces

-- Align indent to next multiple value of shiftwidth. For its meaning,
-- see http://vim.1045645.n5.nabble.com/shiftround-option-td5712100.html
vim.cmd "set shiftround"

vim.cmd "set ruler"
vim.cmd "set undolevels=1000"

-- use backspace to delete
vim.cmd "set backspace=indent,eol,start"

-- spell-check
vim.cmd "set spelllang=en,de"

-- Go to start or end of line easier
vim.keymap.set("n", "H", "^")
vim.keymap.set("x", "H", "^")
vim.keymap.set("n", "L", "g_")
vim.keymap.set("x", "L", "g_")

-- Change text without putting the text into register,
-- see https://stackoverflow.com/q/54255/6064933

-- Paste mode toggle, it seems that Neovim's bracketed paste mode
-- does not work very well for nvim-qt, so we use good-old paste mode
vim.cmd "set pastetoggle=<F12>"

-- vim.keymap.set("i", <C-d>, <Esc>)

-- Persistent undo even after you close a file and re-open it.
local prefix = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.local")
vim.opt.undodir = { prefix .. "/nvim/undo" }
vim.opt.backupdir = { prefix .. "/nvim/backup" }

-- Copy to clipboard
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-c>", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+yg_')

-- " Paste from clipboard
vim.keymap.set("n", "<leader>p", "+p")
vim.keymap.set("n", "<leader>P", "+P")
vim.keymap.set("v", "<leader>p", "+p")
vim.keymap.set("v", "<leader>P", "+P")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- include transparency
function RecolorThings(color)
    color = color or "tokyonight-night"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

RecolorThings()


