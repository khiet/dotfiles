return {
  { "benmills/vimux" },
  {
    "janko-m/vim-test",
    config = function()
      vim.g.VimuxOrientation = "h"
      vim.g.VimuxHeight = "25"
      vim.g['test#strategy'] = 'vimux'
      vim.g['test#javascript#runner'] = 'vitest'

      vim.g['test#javascript#vitest#executable'] = 'pnpm run test'

      vim.keymap.set('n', '<leader>T', vim.cmd.TestNearest, { noremap = true })
      vim.keymap.set('n', '<leader>tl', vim.cmd.TestLast, { noremap = true })
      vim.keymap.set('n', '<leader>tf', vim.cmd.TestFile, { noremap = true })
    end
  }
}
