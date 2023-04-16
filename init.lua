require("nvim.sets")
require("nvim.keymaps")
require("nvim.functions")
require("nvim.lazy")

vim.cmd('colorscheme dracula_pro')

vim.o.ch = 1

-- spellcheck
vim.cmd("au BufRead,BufNewFile *.md set filetype=markdown")
vim.cmd("au FileType markdown setlocal spell")
vim.cmd("au FileType gitcommit setlocal spell")

-- highlight trailing whitespaces
vim.cmd([[au BufWritePre * match ExtraWhitespace /\s\+$/]])
vim.cmd("hi ExtraWhitespace guibg=#ff5555")

-- vim_current_word
vim.cmd("hi CurrentWord gui=underline")
vim.cmd("hi CurrentWordTwins gui=underline")
