vim.g.mapleader = " "

local set = vim.keymap.set

-- disable command-line window
set('n', 'q:', '<NOP>', { noremap = true })
-- disable ex-mode
set('n', 'Q', '<NOP>', { noremap = true })

set('n', 'Q', 'q', { noremap = true })
set('n', 'q', '<NOP>', { noremap = true })

set('n', '<Up>', '<NOP>', { noremap = true })
set('n', '<Down>', '<NOP>', { noremap = true })
set('n', '<Left>', '<NOP>', { noremap = true })
set('n', '<Right>', '<NOP>', { noremap = true })

set('n', '<C-j>', '<C-w><C-j>', { noremap = true })
set('n', '<C-k>', '<C-w><C-k>', { noremap = true })
set('n', '<C-l>', '<C-w><C-l>', { noremap = true })
set('n', '<C-h>', '<C-w><C-h>', { noremap = true })

set('n', '<leader>w', vim.cmd.w, { noremap = true })
set('n', '<leader>x', vim.cmd.x, { noremap = true })
set('n', '<leader>q', vim.cmd.q, { noremap = true })
set('n', '<leader>e', ":e!<CR>", { noremap = true })
set('n', '<leader>Q', ":q!<CR>", { noremap = true })

-- http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
set('x', 'p', [[p:let @+=@0<CR>:let @"=@0<CR>]], { silent = true, noremap = true })

-- switch between the last two files
set('n', '<leader><leader>', '<C-^>', { noremap = true })

set({ 'n', 'v' }, '<<', '<gv', { noremap = true })
set({ 'n', 'v' }, '>>', '>gv', { noremap = true })

set('n', '<leader>=', "<C-w>=", { noremap = true })

set('n', '[b', vim.cmd.bp, { silent = true, noremap = true })
set('n', ']b', vim.cmd.bn, { silent = true, noremap = true })
set('n', '<leader>bd', vim.cmd.bd, { noremap = true })

set('n', '<leader>h', vim.cmd.noh, { noremap = true })

set({ 'n', 'v' }, '<leader>s', [[:s//]], { noremap = true })
set('n', '<leader>s', [[:%s//]], { noremap = true })
set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/]], { noremap = true })

-- https://vi.stackexchange.com/a/22889
set('n', '<leader>k', [[<Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>]], { noremap = true })

set("n", "J", "mzJ`z")
set({ "n", "v" }, "K", [[:s/ /\r/g<CR>]])
set("n", "<C-d>", "<C-d>zz", { noremap = true })
set("n", "<C-u>", "<C-u>zz", { noremap = true })

set("n", "<leader>ev", ':e <C-R>=expand($HOME."/dotfiles/")<CR><CR>', { noremap = true })
set("n", "<leader>ez", ':e <C-R>=expand($HOME."/dotfiles/_zshrc")<CR><CR>', { noremap = true })
set("n", "<leader>et", ':e <C-R>=expand($HOME."/dotfiles/_tmux.conf")<CR><CR>', { noremap = true })
vim.cmd([[au BufEnter,BufWinEnter _zshrc set filetype=zsh]])
vim.cmd([[au BufEnter,BufWinEnter _tmux.conf set filetype=tmux]])
