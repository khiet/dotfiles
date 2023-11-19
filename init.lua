require("nvim.sets")
require("nvim.keymaps")
require("nvim.functions")
require("nvim.lazy")

vim.o.ch = 1

-- spellcheck
vim.cmd("au FileType markdown setlocal spell spelllang=en_us")
vim.cmd("au FileType gitcommit setlocal spell spelllang=en_us")

-- highlight trailing whitespaces
vim.cmd([[au BufWritePre * match ExtraWhitespace /\s\+$/]])
vim.cmd("hi ExtraWhitespace guibg=#ff5555")

-- vim_current_word
vim.cmd("hi CurrentWord gui=underline")
vim.cmd("hi CurrentWordTwins gui=underline")

-- set filetype
vim.cmd([[au BufRead,BufNewFile *.inky-haml set filetype=haml]])
-- set filetype overwriting plugins
vim.cmd("au BufEnter,BufWinEnter *.yml set syntax=yaml")
