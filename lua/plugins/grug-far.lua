return {
  'MagicDuck/grug-far.nvim',
  init = function()
    vim.keymap.set('n', '<leader>S', ':GrugFar<CR>', { silent = true, noremap = true })
  end,
  config = function()
    require('grug-far').setup({
      keymaps = {
        qflist = false,
      }
    });
  end
}
