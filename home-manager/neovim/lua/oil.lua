-- oil options
require("oil").setup({
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
  default_file_explorer = true;
  keymaps = {
    ["<C-p>"] = false,
    ["<C-h>"] = false,
    ["<C-l>"] = false,
  }
})

-- open oil explorer
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
