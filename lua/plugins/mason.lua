-- :help lspconfig-all to list available servers
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
        'ts_ls',
        'eslint',
        'jsonls',
        'lua_ls'
      },
    }
  end
}
