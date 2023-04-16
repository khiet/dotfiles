-- general
vim.o.ch = 0

-- nvim-colorizer
require'colorizer'.setup()

-- leap
require('leap').set_default_keymaps()

-- comment-nvim
require('Comment').setup({
  mappings = {
    basic = false,
    extra = false,
  },
})

vim.keymap.set('n', '<leader>cc', '<Plug>(comment_toggle_linewise_current)')
vim.keymap.set('x', '<leader>cc', '<Plug>(comment_toggle_linewise_visual)')
