vim.cmd "syntax on"

-- change leader key
vim.g.mapleader = " "

vim.cmd "colorscheme tokyonight-night"

-- dynamic line-numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- disable beep
vim.opt.belloff="all"

vim.opt.termguicolors = true
vim.opt.updatetime = 50 -- not sure if 50 is safe, maybe increase this

vim.opt.completeopt = {'menu', 'menuone', 'noselect' }

vim.opt.hlsearch = false -- don't keep search highlighted
vim.opt.incsearch = true -- incremental search rocks

-- Ignore case in general, but become case-sensitive when uppercase is present
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tab settings
-- https://gist.github.com/LunarLambda/4c444238fb364509b72cfb891979f1dd
vim.opt.tabstop = 4       -- visual spaces per tab
vim.opt.softtabstop = -1  -- spaces inserted on <Tab> and <Backspace>, -1 means use shiftwidth
vim.opt.shiftwidth = 2    -- blanks used for << and >>
vim.opt.expandtab = true  -- expand tab to spaces
vim.opt.smarttab = true -- use shiftwidth for identation at start of line

-- indenting
vim.opt.autoindent = true  -- use indent from last line
vim.opt.cindent = true -- enable c indenting

-- Scroll and wrap
vim.opt.wrap = false        -- disable line-wrap
vim.opt.scrolloff = 8
-- vim.opt.colorcolumn = "80"

-- Align indent to next multiple value of shiftwidth. For its meaning,
-- see http://vim.1045645.n5.nabble.com/shiftround-option-td5712100.html
vim.opt.shiftround = true

vim.opt.ruler = true
vim.opt.undolevels = 1000

-- use backspace to delete
vim.opt.backspace = "indent,eol,start"

-- spell-check
vim.opt.spelllang = "en,de"

-- Paste mode toggle, it seems that Neovim's bracketed paste mode
-- does not work very well for nvim-qt, so we use good-old paste mode
-- vim.opt.pastetoggle = "<F12>"

-- vim.keymap.set("i", <C-d>, <Esc>)

-- Persistent undo even after you close a file and re-open it.
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.backupdir = { prefix .. "/nvim/backup" }

-- include transparency
function RecolorThings(color)
    color = color or "tokyonight-night"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

RecolorThings()


