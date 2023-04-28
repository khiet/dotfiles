vim.g.mapleader = " "

local set = vim.keymap.set

local opt_n =  { noremap = true }
local opt_sn = { silent = true, noremap = true }

-- disable command-line window
set('n', 'q:', '<NOP>', opt_n)
-- disable ex-mode
set('n', 'Q', '<NOP>', opt_n)

set('n', 'Q', 'q', opt_n)
set('n', 'q', '<NOP>', opt_n)

set('n', '<Up>', '<NOP>', opt_n)
set('n', '<Down>', '<NOP>', opt_n)
set('n', '<Left>', '<NOP>', opt_n)
set('n', '<Right>', '<NOP>', opt_n)

set('n', '<C-j>', '<C-w><C-j>', opt_n)
set('n', '<C-k>', '<C-w><C-k>', opt_n)
set('n', '<C-l>', '<C-w><C-l>', opt_n)
set('n', '<C-h>', '<C-w><C-h>', opt_n)

set('n', '<leader>w', vim.cmd.w, opt_n)
set('n', '<leader>x', vim.cmd.x, opt_n)
set('n', '<leader>q', vim.cmd.q, opt_n)
set('n', '<leader>e', ":e!<CR>", opt_n)
set('n', '<leader>Q', ":q!<CR>", opt_n)

-- http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
set('x', 'p', [[p:let @+=@0<CR>:let @"=@0<CR>]], opt_sn)

-- switch between the last two files
set('n', '<leader><leader>', '<C-^>', opt_n)

set({ 'n', 'v' }, '<<', '<gv', opt_n)
set({ 'n', 'v' }, '>>', '>gv', opt_n)

set('n', '<leader>=', "<C-w>=", opt_n)

set('n', '[b', vim.cmd.bp, opt_sn)
set('n', ']b', vim.cmd.bn, opt_sn)
set('n', '<leader>bd', vim.cmd.bd, opt_n)

set('n', '<leader>h', vim.cmd.noh, opt_n)

set({ 'n', 'v' }, '<leader>s', [[:s//]], opt_n)
set('n', '<leader>s', [[:%s//]], opt_n)
set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/]], opt_n)

-- https://vi.stackexchange.com/a/22889
set('n', '<leader>k', [[<Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>]], opt_n)

set("n", "J", "mzJ`z")
set({ "n", "v" }, "K", [[:s/ /\r/g<CR>]])
set("n", "<C-d>", "<C-d>zz", opt_n)
set("n", "<C-u>", "<C-u>zz", opt_n)

set("n", "<leader>ev", ':e <C-R>=expand($HOME."/dotfiles/")<CR><CR>', opt_n)
set("n", "<leader>ez", ':e <C-R>=expand($HOME."/dotfiles/_zshrc")<CR><CR>', opt_n)
set("n", "<leader>et", ':e <C-R>=expand($HOME."/dotfiles/_tmux.conf")<CR><CR>', opt_n)
vim.cmd([[au BufEnter,BufWinEnter _zshrc set filetype=zsh]])
vim.cmd([[au BufEnter,BufWinEnter _tmux.conf set filetype=tmux]])
