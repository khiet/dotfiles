return {
  'MagicDuck/grug-far.nvim',
  init = function()
    vim.keymap.set('n', '<leader>S', ':GrugFar<CR>', { silent = true, noremap = true })
  end,
  config = function()
    -- https://github.com/MagicDuck/grug-far.nvim/blob/main/lua/grug-far/opts.lua
    require('grug-far').setup({
      keymaps = {
        qflist = false,
        refresh = { n = '<localleader>R' },
      }
    });
  end
}
