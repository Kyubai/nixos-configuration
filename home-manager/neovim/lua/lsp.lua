-- lsp options
local lsp = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("luasnip.loaders.from_vscode").lazy_load()

local servers = {
    'rust_analyzer',
    'lua_ls',
    'nixd',
}

for _, name in pairs(servers) do
    lsp[name].setup {
    -- on_attach = on_attach,
	capabilities = lsp_capabilities,
    }
end


