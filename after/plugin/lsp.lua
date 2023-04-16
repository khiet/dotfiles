-- mason
require("mason").setup()

-- nvim-cmp
vim.o.completeopt="menu,menuone,noselect"

-- https://github.com/hrsh7th/nvim-cmp/wiki/Language-Server-Specific-Samples#rust-with-rust-toolsnvim
local cmp = require'cmp'
cmp.setup({
  completion = {
    autocomplete = false,
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }),
})

-- nvim-lspconfig
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- https://neovim.io/doc/user/diagnostic.html#diagnostic-api
local diagnostic_format = function(diagnostic)
  return string.format("(%s: %s) %s", diagnostic.code, diagnostic.source, diagnostic.message)
end

vim.diagnostic.config({
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
    spacing = 0,
    format = diagnostic_format,
  },
})

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>F', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
end

require'lspconfig'.solargraph.setup({
  on_attach = on_attach,
})
require'lspconfig'.tsserver.setup({
  on_attach = on_attach,
})
require'lspconfig'.eslint.setup({
  on_attach = on_attach,
})
require'lspconfig'.tailwindcss.setup({
  on_attach = on_attach,
})
require'lspconfig'.jsonls.setup({
  on_attach = on_attach,
})
require'lspconfig'.volar.setup({
  on_attach = on_attach,
  init_options = {
    typescript = {
      tsdk = "/opt/homebrew/lib/node_modules/typescript/lib"
    }
  }
})

-- rust-tools
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("rust-tools").setup({
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  }
})
