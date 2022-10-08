-- nvim-tree
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "l", action = "edit" },
        { key = "Y", action = "copy_absolute_path" },
        { key = "o", action = "system_open" },
      },
    },
  },
  renderer = {
    icons = {
      glyphs = {
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "R",
          untracked = "??",
          deleted = "D",
          ignored = "!!",
        },
      },
    },
  },
})

-- nvim-colorizer
require'colorizer'.setup()

-- nvim-tree-sitter
require'nvim-treesitter.configs'.setup({
    ensure_installed = { "javascript", "typescript", "rust" },
    highlight = { enable = true, additional_vim_regex_highlighting = false, },
  })

-- hop
require'hop'.setup()
vim.api.nvim_set_keymap('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})

-- nvim-lspconfig
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, bufopts)
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
require'lspconfig'.yamlls.setup({
    on_attach = on_attach,
  })

-- general
vim.o.ch = 0
