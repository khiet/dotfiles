return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },
  cmd = "Mason",
  config = function()
    require("mason").setup()
  end
}
