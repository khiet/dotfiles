vim.g.mapleader = " "

-- disable command-line window
vim.keymap.set('n', 'q:', '<NOP>', { noremap = true })
-- disable ex-mode
vim.keymap.set('n', 'Q', '<NOP>', { noremap = true })

vim.keymap.set('n', 'Q', 'q', { noremap = true })
vim.keymap.set('n', 'q', '<NOP>', { noremap = true })

vim.keymap.set('n', '<Up>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Down>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Left>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Right>', '<NOP>', { noremap = true })

vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { noremap = true })

vim.keymap.set('n', '<leader>w', vim.cmd.w, { noremap = true })
vim.keymap.set('n', '<leader>x', vim.cmd.x, { noremap = true })
vim.keymap.set('n', '<leader>q', vim.cmd.q, { noremap = true })
vim.keymap.set('n', '<leader>Q', ":q!<CR>", { noremap = true })

-- switch between the last two files
vim.keymap.set('n', '<leader><leader>', '<C-^>', { noremap = true })

vim.keymap.set({'n', 'v'}, '<<', '<gv', { noremap = true })
vim.keymap.set({'n', 'v'}, '>>', '>gv', { noremap = true })

vim.keymap.set('n', '<leader>=', "<C-w>=", { noremap = true })

vim.keymap.set('n', '[b', vim.cmd.bp, { silent = true, noremap = true })
vim.keymap.set('n', ']b', vim.cmd.bn, { silent = true, noremap = true })
vim.keymap.set('n', '<leader>bd', vim.cmd.bd, { noremap = true })

vim.keymap.set('n', '<leader>h', vim.cmd.noh, { noremap = true })

vim.keymap.set('n', '<leader>s', ":%s//", { noremap = true })
vim.keymap.set({'n', 'v'}, '<leader>s', [[:s//]], { noremap = true })

-- https://vi.stackexchange.com/a/22889
vim.keymap.set('n', '<leader>k', [[<Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>]], { noremap = true })

vim.keymap.set("n", "<leader>ev", ':e <C-R>=expand($HOME."/dotfiles/lua/nvim/")<CR><CR>', { noremap = true })
vim.keymap.set("n", "<leader>ez", ':e <C-R>=expand($HOME."/dotfiles/_zshrc")<CR><CR>', { noremap = true })
vim.keymap.set("n", "<leader>et", ':e <C-R>=expand($HOME."/dotfiles/_tmux.conf")<CR><CR>', { noremap = true })
