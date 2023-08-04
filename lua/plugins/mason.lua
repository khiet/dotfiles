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
        'solargraph',
        'tsserver',
        'eslint',
        'tailwindcss',
        'jsonls',
        'lua_ls',
        'rust_analyzer',
      },
      automatic_installation = true,
    }
  end
}
