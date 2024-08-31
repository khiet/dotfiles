return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },
  cmd = "Mason",
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup {
      ensure_installed = {
        'ruby_lsp',
        'tsserver',
        'eslint',
        'tailwindcss',
        'jsonls',
        'lua_ls',
        'volar'
      },
      automatic_installation = true,
    }
  end
}
