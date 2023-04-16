require("nvim.sets")
require("nvim.keymaps")
require("nvim.functions")
require("nvim.lazy")

vim.cmd('colorscheme dracula_pro')
vim.o.ch = 0

vim.cmd("au BufWinEnter *.md setlocal syntax=markdown")

-- highlight trailing whitespaces
vim.cmd([[au BufWritePre * match ExtraWhitespace /\s\+$/]])
vim.cmd("hi ExtraWhitespace guibg=#ff5555")

-- vim_current_word
vim.cmd("hi CurrentWord gui=underline")
vim.cmd("hi CurrentWordTwins gui=underline")
