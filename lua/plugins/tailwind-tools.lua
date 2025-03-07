return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
  },
  opts = {},
  init = function()
    vim.keymap.set('n', '<leader>gc', ':TailwindConcealToggle<CR>', { silent = true, noremap = true })
  end,
}
