-- lsp options
local lsp = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("luasnip.loaders.from_vscode").lazy_load()

local lsp_on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "[w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, opts)
  vim.keymap.set("n", "]w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, opts)
  vim.keymap.set("n", "[e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, opts)
  vim.keymap.set("n", "]e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

local servers = {
  'rust_analyzer',
  'lua_ls',
}

for _, name in pairs(servers) do
  lsp[name].setup {
    on_attach = lsp_on_attach,
    capabilities = lsp_capabilities,
  }
end

  lsp.nixd.setup({
    settings = {
      nixd = {
        formatting = {
          -- command = { "%!alejandra -qq" },
          command = { "alejandra" },
        },
      },
    },
    on_attach = lsp_on_attach,
    capabilities = lsp_capabilities,
  })
