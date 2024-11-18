-- Go to start or end of line easier
vim.keymap.set("n", "H", "^")
vim.keymap.set("x", "H", "^")
vim.keymap.set("n", "L", "g_")
vim.keymap.set("x", "L", "g_")

-- Copy to clipboard
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-c>", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>y", '"+y')

-- " Paste from clipboard
vim.keymap.set("n", "<leader>p", "+p")
vim.keymap.set("n", "<leader>P", "+P")
vim.keymap.set("v", "<leader>p", "+p")
vim.keymap.set("v", "<leader>P", "+P")

-- move highlighted lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z") -- J stays at start of line

-- keep cursor in the middle of the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Change text without putting the text into register,
-- see https://stackoverflow.com/q/54255/6064933
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- this button is useless
-- vim.keymap.set("n", "Q", "<nop>")

-- fast quit to normal mode
vim.keymap.set("i", "jk", "<Esc>")


vim.keymap.set("n", "Q", function()
  vim.lsp.buf.format()
end)

-- swap { and } to keep in line with j and k
vim.keymap.set("n", "{", "}")
vim.keymap.set("n", "}", "{")

-- QuickFix Navigation
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- search and replace current word
vim.keymap.set("n", "<leader>s", ":%s,\\<<C-r><C-w>\\>,<C-r><C-w>,gI<Left><Left><Left>")

-- make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
