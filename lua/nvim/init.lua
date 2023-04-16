require("nvim.sets")
require("nvim.keymaps")
require("nvim.lazy")

vim.cmd('colorscheme dracula_pro')

-- vim_current_word
vim.cmd("hi CurrentWord gui=underline")
vim.cmd("hi CurrentWordTwins gui=underline")

-- vim-easy-align
vim.keymap.set({'n', 'x'}, 'ga', "<Plug>(EasyAlign)", { noremap = true })
vim.keymap.set('n', 'ga', "<Plug>(EasyAlign)", { noremap = true })

-- vim-polyglot
vim.g.csv_no_conceal = 1
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_conceal = 0

-- vim-argwrap
vim.keymap.set('n', 'gS', vim.cmd.ArgWrap, { silent = true, noremap = true })

-- markdown-preview
vim.keymap.set('n', '<leader>em', "<Plug>MarkdownPreviewToggle", { noremap = true })

-- functions
function delete_trailing_whitespaces()
  local s = vim.fn.getreg('/')
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')

  vim.cmd('%s/\\s\\+$//e')

  vim.fn.setreg('/', s)
  vim.fn.cursor(l, c)
end

vim.keymap.set('n', '<leader>td', delete_trailing_whitespaces, { noremap = true })
-- vim.keymap.set('n', '<leader>cq', replace_curly_quotes, { noremap = true })
