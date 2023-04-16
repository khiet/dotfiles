-- turn off all key mappings
vim.g.gitgutter_map_keys = 0
vim.g.gitgutter_grep = 'rg'

vim.keymap.set('n', '[c', '<Plug>(GitGutterPrevHunk)', { silent = true, noremap = true })
vim.keymap.set('n', ']c', '<Plug>(GitGutterNextHunk)', { silent = true, noremap = true })
