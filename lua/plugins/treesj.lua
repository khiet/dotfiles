return {
  "Wansmer/treesj",
  init = function()
    vim.keymap.set('n', '<leader>m', ':TSJToggle<CR>', { silent = true, noremap = true })
  end,
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
  end,
}
