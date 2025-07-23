return {
  {
    "janko-m/vim-test",
    keys = { '<leader>T', '<leader>tl', '<leader>tf' },
    config = function()
      vim.g['test#preserve_screen'] = 0
      vim.g['test#neovim_sticky#kill_previous'] = 1
      vim.g['test#strategy'] = 'neovim_sticky'
      vim.g['test#neovim#term_position'] = 'vert'

      vim.keymap.set('n', '<leader>T', vim.cmd.TestNearest, { noremap = true })
      vim.keymap.set('n', '<leader>tl', vim.cmd.TestLast, { noremap = true })
      vim.keymap.set('n', '<leader>tf', vim.cmd.TestFile, { noremap = true })
    end
  }
}
